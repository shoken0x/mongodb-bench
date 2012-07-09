require 'mysql'

class MysqlUtil
  DEFAULT_DATABASE = 'benchmark'
  DEFAULT_TABLE = DEFAULT_DATABASE+'.time_insert'
  DEFAULT_TABLE_SCHEMA = DEFAULT_TABLE + '(time text)' 

  def initialize(host='localhost', username='root', password='')
    @db = Mysql.connect(host, username, password)
  end

  def create_db(database=DEFAULT_DATABASE)
    @db.query "CREATE DATABASE IF NOT EXISTS #{database}"
  end

  def create_table(tableschema=DEFAULT_TABLE_SCHEMA)
    @db.query "CREATE TABLE IF NOT EXISTS #{tableschema}"
  end

  def trancate_table(table=DEFAULT_TABLE)
    @db.query "TRUNCATE #{table}"
  end

  def insert_value(table=DEFAULT_TABLE)
    @db.query "INSERT INTO #{table} VALUES('#{Time.now.to_s}')"
  end

  def select()

  end
  
  def update()

  end

  def testm(str)
    puts str
  end

end
