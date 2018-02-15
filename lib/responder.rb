require 'Date'
require 'Time'
require './lib/request_parser'
require './lib/game'
require 'pry'

class Responder
  attr_reader :path,
              :verb,
              :request,
              :count

  def initialize(request, count)
    @request = request
    @count   = count
    @game    = nil
  end

  def endpoint_map
    {
      "/" => :debug_endpoint,
      "/hello" => :hello_endpoint,
      "/datetime" => :datetime_endpoint,
      "/shutdown" => :shutdown_endpoint,
      "/game" => :game_endpoint,
      "/start_game" => :start_game_endpoint,
      "/word_search" => :word_search_endpoint
    }
  end

  def endpoint
    return not_found if !endpoint_map[request.path]
    self.send(endpoint_map[request.path])
  end

  def debug_endpoint
    "</pre>" + ("\n") + ("\t") +
    "Verb:    #{request.verb}
    Path:     #{request.path}
    Protocol: #{request.protocol}
    Host:     #{request.host}
    Port:     #{request.port}
    Origin:   #{request.origin}
    Accept:   #{request.encoding},#{request.accept};#{request.language}" +
    "</pre>"
  end

  def hello_endpoint
    "Hello, World! (#{count})"
  end

  def datetime_endpoint
    Date.today.strftime("%I:%M%p on %A, %B %-d, %Y")
  end

  def shutdown_endpoint
    "Total Requests: #{count}"
  end

  def start_game_endpoint
    return start_game if request.get?
    not_found
  end

  def game_endpoint
    return @game.get  if request.get?
    return @game.post if request.post?
    not_found
  end

  def word_search_endpoint
    return search_result if request.get?
    not_found
  end

  def not_found
    "404: Not Found :("
  end

  def search_result
    request.parameters.map do |word|
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
end



# def endpoint  #build out alternatives for get/post...e.g. word_search does not work with post?
#   case path
#   when "/"            then debug_endpoint
#   when "/hello"       then hello_endpoint
#   when "/datetime"    then datetime_endpoint
#   when "/shutdown"    then shutdown_endpoint
#   when "/game"        then game_endpoint
#   when "/start_game"  then start_game_endpoint
#   when "/word_search" then word_search_endpoint
#   else not_found end
# end
