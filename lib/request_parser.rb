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
              :content_length,
              :count

  def initialize
    @count = 0
  end

  def parse_all(request_lines)
    @count += 1
    parse_verb_path_protocol(request_lines)
    parse_parameters unless parameters.nil?
    parse_remainder(request_lines)
  end

  def parse_verb_path_protocol(request_lines)
    @verb, @path, @protocol = request_lines[0].split(' ')
    @path, @parameters = @path.split('?')
  end

  def parse_parameters
    @parameters = parameters.split('&').map do |parameter|
      parameter.split('=')
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
    when 'host'   then @host, @port = content.split(':')
    when 'origin' then @origin = content
    when 'accept' then @accept = content
    when 'accept-encoding' then @encoding = content
    when 'accept-language' then @language = content
    when 'content-length'  then @content_length = content.to_i
    else nil
    end
  end
end
