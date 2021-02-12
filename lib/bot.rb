class Bot
  def take_action(action, params)
    action = URI "https://slack.com/api/#{action}"
    send_query(action, params)
  end

  def run
    server = TCPServer.new('localhost', 3000)

    loop {
      client = server.accept
      request = client.readpartial(2048)
      puts request
      request = Request.new(request)
      request.parse
      request.parse_body
      response = Response.new
      response.constract_response(request.body)
      response.send(client)
      if (request.body['event']['text'] == 'hi')
        params = { token: ENV['SLACK_BOT_TOKEN'], channel: request.body['event']['channel'], text: 'Hello'}
        take_action('chat.postMessage', params)
      end

      client.close
    }
  end

  private
  
  def send_query(action, params)
    action.query = URI.encode_www_form(params)
    response = Net::HTTP.get_response(action)
  end
end