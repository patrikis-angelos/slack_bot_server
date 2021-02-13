class Request
  attr_reader :raw_request, :head, :body

  def initialize(raw_request)
    @raw_request = raw_request
  end

  def parse
    method, path, version = raw_request.lines[0].split
    @head = {
      path: path,
      method: method,
      headers: parse_headers(raw_request)
    }
  end

  def parse_body
    if @head[:headers][:ContentType] == "application/json"
      b = raw_request.lines[-1]
      @body = JSON.parse(b)
    else
      @body = raw_request.lines[-1]
    end
  end

  private

  def parse_headers(raw_request)
    headers = {}
    raw_request.lines[1..-1].each_with_index do |line, i|
      if line == "\r\n"
        return headers
      end
      header, value = line.split
      header = normalize(header)
      headers[header] = value
    end
  end

  def normalize(header)
    header.gsub(/[:-]/, "").to_sym
  end
end