require_relative 'commands'

class Bot
  include Commands

  def initialize
    @commands = Commands.instance_methods
  end

  def run
    server = TCPServer.new('localhost', 3000)
    puts @commands

    loop {
      client = server.accept
      raw_request = client.readpartial(2048)

      request = Request.new(raw_request)
      request.parse
      request.parse_body

      response = Response.new
      if authenticate(request)
        response.constract_response(200, request.body)
        if @commands.any?(request.body['event']['text'].to_sym)
          send(request.body['event']['text'].to_sym, request.body)
        end
      else
        response.constract_response(403)
      end
      response.send(client)
      client.close
    }
  end

  private

  def authenticate(request)
    data = request.raw_request.lines[-1]
    timestamp = request.head[:headers][:XSlackRequestTimestamp]
    basestring = "v0:" + timestamp.to_s + ":" + data.to_s
    key = ENV['SLACK_SIGNIN_SECRET']
    value = OpenSSL::HMAC.hexdigest("SHA256", key, basestring)
    value = "v0=" + value
    request.head[:headers][:XSlackSignature].eql? value
  end

  def take_action(action, params)
    action = URI "https://slack.com/api/#{action}"
    send_query(action, params)
  end

  def send_query(action, params)
    action.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(action)
  end
end