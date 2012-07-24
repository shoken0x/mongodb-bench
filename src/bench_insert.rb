require 'mongo'

db_name='test'
coll_name='time_insert' 

db_mongo = Mongo::Connection.new.db(db_name)
coll = db_mongo.collection(coll_name)

######################################################################
### Methods

def rand_str(digits)
  charset = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
  Array.new(digits){charset[rand(charset.size)]}.join
end

def rand_num(digits)
  numset = ('0'..'9').to_a
  Array.new(digits){numset[rand(numset.size)]}.join
end

###############################################################

require 'mysql'
username = 'root'
password = ''
database = 'mysql'

db_mysql = Mysql.connect('localhost', username, password, database)

sql_create_db = 'CREATE DATABASE IF NOT EXISTS test'
sql_create_table = 'CREATE TABLE IF NOT EXISTS test.time_insert(id INT NOT NULL PRIMARY KEY, time TEXT, num INT, body TEXT)'
sql_trancate_table = 'TRUNCATE test.time_insert'
sql_select_table_with_index = "SELECT id from test.time_insert where id = #{rand(100)}"
sql_select_table_without_index = "SELECT num from test.time_insert where num = #{rand_num(4)}"
sql_update_num = "UPDATE test.time_insert SET num = #{rand_num(4)} where id < 100"

db_mysql.query(sql_create_db)
db_mysql.query(sql_create_table)


######################################################################
### init 
require 'parallel'

puts '==== Clean collection and table ===='
coll.drop
db_mysql.query(sql_trancate_table)

puts
puts '==== Create random data ===='

max_loop = 100000
rand_num_a = Array.new(max_loop)
rand_str_a = Array.new(max_loop)

set_num = lambda {|num|
  num = rand_num(4)
}

set_str = lambda {|str|
  str = rand_str(1024)
}

rand_num_a = Parallel.map(rand_num_a, &set_num)
rand_str_a = Parallel.map(rand_str_a, &set_str)

coll.create_index("id")

######################################################################
######################################################################
### Bench
 
require 'rbench'

puts
puts "Bench: MySQL vs MongoDB"
#[10,100,1000,10000,max_loop].each do |times|
[max_loop].each do |times|
  puts "#{times} times:"
  RBench.run(times) do
    report("INSERT:MongoDB ") { |i| coll.insert({:id => i,
                                          :time => Time.now,
                                          :num => rand_num_a[i].to_i,
                                          :body => rand_str_a[i] }) } 

    report("INSERT:MySQL   ") { |i| db_mysql.query("INSERT INTO test.time_insert VALUES('#{i}',
                                                                                 '#{Time.now.to_s}',
                                                                                 '#{rand_num_a[i].to_i}',
                                                                                 '#{rand_str_a[i]}')") }


    report("SELECT WITH INDEX:MongoDB ") { |i| coll.find({:id => rand(100)}) }

    report("SELECT WITH INDEX:MySQL   ") { |i| db_mysql.query(sql_select_table_with_index) }

    report("SELECT WITHOUT INDEX:MongoDB ") { |i| coll.find({:num => rand_num(4)}) }
    
    report("SELECT WITHOUT INDEX:MySQL   ") { |i| db_mysql.query(sql_select_table_without_index) }

    report("UPDATE:MySQL   ") { |i| db_mysql.query(sql_update_num) }

    report("UPDATE:MongoDB ") { |i| coll.update( {"id" => {"$lt" => 10}}, 
                                                 {"$set" => {:num => rand_num(4)}},
                                                 {:multi => true }) }
  end
  puts ""
end

