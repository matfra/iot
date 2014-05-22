#!/usr/bin/ruby
require "net/http"
require "json"
require "mongo"

#DB Section
mongo_client = Mongo::MongoClient.new("localhost", 27017)
db = mongo_client.db("spark")
col = db.collection('light')

puts col.find.to_a


