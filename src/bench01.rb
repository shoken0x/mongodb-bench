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
sql_create_table = 'CREATE TABLE IF NOT EXISTS test.time_insert(time text)'
sql_trancate_table = 'TRUNCATE test.time_insert'
sql_insert = "INSERT INTO test.time_insert VALUES('#{Time.now.to_s}')"

db_mysql.query(sql_create_db)
db_mysql.query(sql_create_table)

######################################################################
### Clean
puts '==== Clean collection and table ===='
coll.drop
db_mysql.query(sql_trancate_table)

######################################################################
######################################################################
### Bench
 
require 'rbench'
 
puts "Bench1: insert time"
[10,100,1000,10000,100000].each do |times|
  puts "#{times} times:"
  RBench.run(times) do
    report("MongoDB ") { coll.insert({:time => Time.now}) } 
    report("MySQL   ") { db_mysql.query(sql_insert) }
  end
  puts ""
end
