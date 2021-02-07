class Request
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def parse
  method, path, version = request.lines[0].split
  {
    path: path,
    method: method,
    headers: parse_headers(request)
  }
  end

  def parse_body
    b = request.lines[-1]
    body = JSON.parse(b)
    return body
  end

  private

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

  def normalize(header)
    header.gsub(":", "").downcase.to_sym
  end
end