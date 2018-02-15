require 'pry'

class RequestParser
  attr_reader :request_lines,
              :verb,
              :path,
              :parameters,
              :protocol,
              :host,
              :port,
              :origin,
              :encoding,
              :accept,
              :language,
              :parameters,
              :content_length

  attr_accessor :count

  def initialize
    @count = 0
  end

  def parse_all(request_lines)
    @count += 1
    parse_verb_path_protocol(request_lines)
    parse_parameters if !parameters.nil?
    parse_remainder(request_lines)
  end

  def parse_verb_path_protocol(request_lines)
    @verb, @path, @protocol = request_lines[0].split(" ")
    @path, @parameters = @path.split("?")
  end

  def parse_parameters
    @parameters = parameters.split("&").map do |parameter|
      parameter.split("=")
    end
  end

  def parse_remainder(request_lines)
    request_lines[1..-1].each do |line|
      prefix, content = line.split(': ')
      set_variable(prefix, content)
    end
    @origin ||= host
  end

  def set_variable(prefix, content)
    case prefix.downcase
    when "host"            then @host, @port = content.split(":")
    when "origin"          then @origin = content
    when "accept"          then @accept = content
    when "accept-encoding" then @encoding = content
    when "accept-language" then @language = content
    when "content-length"  then @content_length = content.to_i
    else nil end
  end

  def parse_guess
    nil
  end

  def get?
    verb == "GET"
  end

  def post?
    verb == "POST"
  end
end


#   @origin = @host
# elsif prefix == "origin"
#   @origin = content
# elsif prefix == "accept"
#   @accept = content
# elsif prefix == "accept-encoding"
#   @accept_encoding = content
# elsif prefix == "accept-language"
#   @accept_language = content
# else
#   nil
# end
