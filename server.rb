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
  request = client.readpartial(2048)
  request = Request.new(request)
  request.parse
  request.parse_body
  puts request.head
  puts request.head[:headers][:ContentType]
  puts request.body
  response = Response.new(200, request.body)
  #response.send(client)
  client.close
}