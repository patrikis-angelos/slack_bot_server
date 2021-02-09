class Response
  attr_reader :response
  def initialize(code, data = "")
    time = Time.now
    day = time.strftime("%A")
    month = time.strftime("%B")
    @response =
    "HTTP/1.1 200 OK\r\n" +
    "Content-type: text/plain\r\n" +
    "\r\n" +
    "#{data['challenge']}\r\n"
  end

  def send(client)
    client.write(@response)
  end
end

#"Date: #{day[0..2]}, #{time.day} #{month[0..2]} #{time.year} #{time.strftime("%k").to_i}:#{time.strftime("%M")}:#{time.strftime("%S")} GMT\r\n" +
