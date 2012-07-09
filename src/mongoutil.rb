require 'mongo'

class MongoUtil
  attr_reader :mongo, :coll

  DEFAULT_DATABASE = 'benchmark'
  DEFAULT_COLLECTION = 'time_insert'

  def initialize(database=DEFAULT_DATABASE,collection=DEFAULT_COLLECTION)
    @mongo = Mongo::Connection.new.db(database)
    @coll = @mongo.collection(collection)
  end

end
