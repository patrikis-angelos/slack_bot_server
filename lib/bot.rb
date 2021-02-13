class Bot
  def run
    server = TCPServer.new('localhost', 3000)

    loop {
      client = server.accept
      request = client.readpartial(2048)
      puts request
      data = request.lines[-1]

      request = Request.new(request)
      request.parse
      request.parse_body

      timestamp = request.head[:headers][:XSlackRequestTimestamp]
      sig_basestring = "v0:" + timestamp.to_s + ":" + data.to_s
      key = ENV['SLACK_SIGNIN_SECRET']
      value = OpenSSL::HMAC.hexdigest("SHA256", key, sig_basestring)
      value = "v0=" + value

      response = Response.new
      if request.head[:headers][:XSlackSignature].eql? value
        response.constract_response(200, request.body)

        if (request.body['type'] == 'event_callback' && request.body['event']['text'] == 'hi')
          params = { token: ENV['SLACK_BOT_TOKEN'], channel: request.body['event']['channel'], text: 'Hello'}
          take_action('chat.postMessage', params)
        end
      else
        response.constract_response(403)
      end
      response.send(client)
      client.close
    }
  end

  private

  def send_query(action, params)
    action.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(action)
  end

  def take_action(action, params)
    action = URI "https://slack.com/api/#{action}"
    send_query(action, params)
  end
end