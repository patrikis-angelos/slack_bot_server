require 'rubygems'
require 'bundler/setup'
require 'dotenv'
require 'socket'
require 'date'
require 'net/http'
require 'json'

require_relative 'lib/response'
require_relative 'lib/request'

Dotenv.load

def take_action(action, params)
  action = URI "https://slack.com/api/#{action}"
  send_query(action, params)
end

def send_query(action, params)
  action.query = URI.encode_www_form(params)
  response = Net::HTTP.get_response(action)
end

server = TCPServer.new('localhost', 3000)

loop {
  client  = server.accept
  request = Request.new(client.readpartial(2048))
  headers = request.parse
  body = request.parse_body
  puts body
  puts body['event']['type']
  puts body['event']['text']
  response = Response.new(200, body)
  #puts response.response
  response.send(client)
  client.close
}