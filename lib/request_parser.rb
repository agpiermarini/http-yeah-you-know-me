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
      prefix, content = line.split(': ')
        if prefix == "Host"
          @host, @port = content.split(":")
          @origin = @host
        elsif prefix == "Origin"
          @origin = content
        elsif prefix == "Accept"
          @accept = content
        elsif prefix == "Accept-Encoding"
          @accept_encoding = content
        elsif prefix == "Accept-Language"
          @accept_language = content
        else
          nil
        end
    end
  end

  def debug_display
    "
     Verb:     #{@verb}
     Path:     #{@path}
     Protocol: #{@protocol}
     Host:     #{@host}
     Port:     #{@port}
     Origin:   #{@origin}
     Accept:   #{@accept_encoding},#{@accept};#{@accept_language}"
  end

  # find what is common to all verbs and parse at initialize
  # remainder parsed in methods below...if statements, case statements?

end
