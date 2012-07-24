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

