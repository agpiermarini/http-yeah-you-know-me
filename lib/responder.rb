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

  def output  #build out alternatives for get/post...e.g. word_search does not work with post?
    case path
    when "/"         then "#{@request.debug_info}"
    when "/hello"    then "Hello, World! (#{@count})"
    when "/datetime" then "#{Date.today.strftime("%I:%M%p on %A, %B %-d, %Y")}"
    when "/shutdown" then "Total Requests: #{@count}"
    when "/word_search" then word_search
    else "404: Not Found :("
    end
  end

  def word_search
    @request.parameters.map do |word|
       "#{word[1].upcase} is #{include_word?(word[1])} known word"
    end.join(",\n")
  end

  def include_word?(word)
    words = File.read("/usr/share/dict/words")
    return "a" if words.include?(word.downcase)
    "not a"
  end
end
