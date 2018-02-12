require 'pry'

class RequestParser
  attr_reader   :verb,
                :path,
                :protocol,
                :host,
                :port,
                :origin,
                :accept_encoding,
                :accept,
                :accept_language

  def initialize(request_lines)
    @verb, @path, @protocol = request_lines[0].split(" ")
    parse(request_lines)
  end

  def parse(request_lines)
    request_lines[1..-1].each do |line|
      prefix, content = line.downcase.split(': ')
      case prefix
      when "host"   then @host, @port = content.split(":")
      when "origin" then @origin = content
      when "accept" then @accept = content
      when "accept-encoding" then @accept_encoding = content
      when "accept-language" then @accept_language = content
      else nil
      end
      @origin ||= @host
    end
  end

  def debug_info
    "
     Verb:     #{@verb}
     Path:     #{@path}
     Protocol: #{@protocol}
     Host:     #{@host}
     Port:     #{@port}
     Origin:   #{@origin}
     Accept:   #{@accept_encoding},#{@accept};#{@accept_language}"
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
