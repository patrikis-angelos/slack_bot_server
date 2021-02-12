class Response
  attr_reader :response
  def constract_response(data = "")
    @response = 
    "HTTP/1.1 200 OK\r\n" +
    "Content-type: text/plain\r\n" +
    "\r\n"
    if (data["type"] == "url_verification")
      @response += "#{data['challenge']}\r\n"
    end
    @response
  end

  def send(client)
    client.write(@response)
  end
end

# time = Time.now
# day = time.strftime("%A")
# month = time.strftime("%B")
# "Date: #{day[0..2]}, #{time.day} #{month[0..2]} #{time.year} #{time.strftime("%k").to_i}:#{time.strftime("%M")}:#{time.strftime("%S")} GMT\r\n" +
