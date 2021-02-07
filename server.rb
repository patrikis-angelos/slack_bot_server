require 'rubygems'
require 'bundler/setup'
require 'dotenv'
require 'socket'
require 'date'
require 'net/http'
require 'json'

Dotenv.load

authed = false

def take_action(action, params)
  action = URI "https://slack.com/api/#{action}"
  send_query(action, params)
end

def send_query(action, params)
  action.query = URI.encode_www_form(params)
  response = Net::HTTP.get_response(action)
end

def parse(request)
  method, path, version = request.lines[0].split

  {
    path: path,
    method: method,
    headers: parse_headers(request)
  }
end

def parse_headers(request)
  headers = {}

  request.lines[1..-1].each_with_index do |line, i|
    if line == "\r\n"
      return headers
    end

    header, value = line.split
    header = normalize(header)
    headers[header] = value
  end
end

def parse_body(request)
  b = request.lines[-1]
  body = JSON.parse(b)

  return body
end

def normalize(header)
  header.gsub(":", "").downcase.to_sym
end

class Response
  attr_reader :response
  def initialize(code, data = "")
    time = Time.now
    day = time.strftime("%A")
    month = time.strftime("%B")
    @response =
    "HTTP/1.1 200 OK\r\n" +
    "Date: #{day[0..2]}, #{time.day} #{month[0..2]} #{time.year} #{time.strftime("%k").to_i - 2}:#{time.strftime("%M")}:#{time.strftime("%S")} GMT\r\n" +
    "Content-type: text/plain\r\n" +
    "\r\n" + 
    "#{data['challenge']}\r\n"
  end

  def send(client)
    client.write(@response)
  end
end

server = TCPServer.new('localhost', 3000)

loop {
  client  = server.accept
  request = client.readpartial(2048)
  headers = parse(request)
  body = parse_body(request)
  puts body
  response = Response.new(200, body)
  #puts response.response
  response.send(client)
  client.close
}