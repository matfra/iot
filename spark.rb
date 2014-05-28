#!/usr/bin/ruby
require "net/http"
require "json"
require "mongo"
require_relative "credentials"

#DB Section
mongo_client = Mongo::MongoClient.new("localhost", 27017)
db = mongo_client.db("spark")
col = db.collection('light')

#Variables
#devices is an array defined into another file for security purposes
#token is defined into another file for security purposes
var = "light"
params = {:access_token => TOKEN}

DEVICES.each { |device|
  url = "https://api.spark.io/v1/devices/" + device + "/" + var 
  uri = URI.parse(url)
  uri.query = URI.encode_www_form(params)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)
  data = JSON.parse(response.body)
  data["time"] = Time.now
#  puts data
  col.insert(data)
#Important note - using to_a pulls all of the full result set into memory and is inefficient if you can process by each individual document. To process with more memory efficiency, use the each method with a code block for the cursor.
}
