require 'mongo'

db_name='test'
coll_name='time_insert' 

db_mongo = Mongo::Connection.new.db(db_name)
coll = db_mongo.collection(coll_name)


###############################################################

require 'mysql'
username = 'root'
password = ''
database = 'mysql'

db_mysql = Mysql.connect('localhost', username, password, database)

sql_create_db = 'CREATE DATABASE IF NOT EXISTS test'
sql_create_table = 'CREATE TABLE IF NOT EXISTS test.time_insert(id int, time text, num int, body text)'
sql_trancate_table = 'TRUNCATE test.time_insert'

db_mysql.query(sql_create_db)
db_mysql.query(sql_create_table)


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

######################################################################
### init 
require 'parallel'

puts '==== Clean collection and table ===='
coll.drop
db_mysql.query(sql_trancate_table)

puts
puts '==== Create random data ===='

max_loop = 1000000
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


######################################################################
######################################################################
### Bench
 
require 'rbench'

puts
puts "Bench1: time_insert"
#[10,100,1000,10000,max_loop].each do |times|
[max_loop].each do |times|
  puts "#{times} times:"
  RBench.run(times) do
    report("MongoDB ") { |i| coll.insert({:id => i,
                                          :time => Time.now,
                                          :num => rand_num_a[i].to_i,
                                          :body => rand_str_a[i] }) } 

    report("MySQL   ") { |i| db_mysql.query("INSERT INTO test.time_insert VALUES('#{i}',
                                                                                 '#{Time.now.to_s}',
                                                                                 '#{rand_num_a[i].to_i}',
                                                                                 '#{rand_str_a[i]}')") }
  end
  puts ""
end

