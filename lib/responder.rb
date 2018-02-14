require 'Date'
require 'Time'
require './lib/request_parser'
require 'pry'

class Responder
  attr_reader :path

  def initialize(request, count)
    @request = request
    @path = @request.path
    @count = count
  end

  def output
    case path
    when "/"         then "#{@request.debug_info}"
    when "/hello"    then "Hello, World! (#{@count})"
    when "/datetime" then "#{Date.today.strftime("%I:%M%p on %A, %B %-d, %Y")}"
    when "/shutdown" then "Total Requests: #{@count}"
    else "401: Not Found :("
    end
  end
end
