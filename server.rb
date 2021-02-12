require 'rubygems'
require 'bundler/setup'
require 'dotenv'
require 'socket'
require 'date'
require 'net/http'
require 'json'

require_relative 'lib/response'
require_relative 'lib/request'
require_relative 'lib/bot'

Dotenv.load

bot = Bot.new
bot.run

# params = { token: ENV['SLACK_API_TOKEN'], channel: data.channel, text: 'Hello', as_user: true }
# client.take_action('chat.postMessage', params)