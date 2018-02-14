require 'Date'
require 'Time'
require './lib/request_parser'
require './lib/game'
require 'pry'

class Responder
  attr_reader :path,
              :verb

  def initialize(request, count)
    @request = request
    @verb    = request.verb
    @path    = request.path
    @count   = count
    @game    = nil
  end

  def call_some_method(method)
    "somethin_typed"
    # method will be a string
    method_name = method.to_sym
    self.send(method_name)
    o = Object.new
    o.send(:some_method)
    o.some_method
    # above are equivalent

    current_user.username
    current_user.try(:username)
  end



  def endpoint_map
    {
      "/" => :debug_endpoint,
      ...
    }
  end

  def endpoint
    return not_found if !endpoint_map[path]
    self.send(endpoint_map[path])
    self.send(:method_name) #symbol method
  endpoint_map[path].call # lambda
  end

  def endpoint  #build out alternatives for get/post...e.g. word_search does not work with post?
    case path
    when "/"            then debug_endpoint
    when "/hello"       then hello_endpoint
    when "/datetime"    then datetime_endpoint
    when "/shutdown"    then shutdown_endpoint
    when "/game"        then game_endpoint
    when "/start_game"  then start_game_endpoint
    when "/word_search" then word_search_endpoint
    else not_found end
  end

  def debug_endpoint
    @request.debug_info
  end

  def hello_endpoint
    "Hello, World! (#{@count})"
  end

  def datetime_endpoint
    Date.today.strftime("%I:%M%p on %A, %B %-d, %Y")
  end

  def shutdown_endpoint
    "Total Requests: #{@count}"
  end

  def start_game_endpoint
    request.get? ? start_game : not_found
  end

  def game_endpoint
    return @game.get  if request.get?
    return @game.post if post?
    not_found
  end

  def word_search_endpoint
    return search_result if get?
    not_found
  end

  def not_found
    "404: Not Found :("
  end

  def search_result
    @request.parameters.map do |word|
       "#{word[1].upcase} is #{include_word?(word[1])} known word"
    end.join(",\n")
  end


  def start_game
    @game = Game.new
    @game.welcome
  end

  def include_word?(word)
    words = File.read("/usr/share/dict/words")
    return "a" if words.include?(word.downcase)
    "not a"
  end

  def get?
    verb == "GET"
  end

  def post?
    @verb == "POST"
  end
end
