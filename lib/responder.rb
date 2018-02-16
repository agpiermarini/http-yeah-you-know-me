require 'socket'
require 'Date'
require './lib/status_codes'
require './lib/request_parser'
require './lib/word_search'
require './lib/game'
require 'pry'

class Responder
  include StatusCodes
  attr_reader :path,
              :verb,
              :server,
              :status_code,
              :location

  def initialize(server)
    @server = server
    @status_code = nil
    @location = nil
    # @game = nil
  end

  def request
    server.request
  end

  def current_client
    server.client
  end

  def endpoint_map
    {
      'GET/' => :debug_endpoint,
      'POST/' => :debug_endpoint,
      'GET/hello' => :hello_endpoint,
      'GET/datetime' => :datetime_endpoint,
      'GET/shutdown' => :shutdown_endpoint,
      'GET/word_search' => :word_search_endpoint,
      'GET/game' => :game_get_endpoint,
      'POST/game' => :game_post_endoint,
      'POST/start_game' => :start_game_endpoint,
      'POST/force_error' => :force_error,
      'GET/force_error' => :force_error
    }
  end

  def verb_path
    request.verb + request.path
  end

  def select_endpoint
    return default_endpoint unless endpoint_map[verb_path]
    send(endpoint_map[verb_path])
  end

  def debug_endpoint
    @status_code = STATUS_CODE[:status_200]
    "Verb:    #{request.verb}
    Path:     #{request.path}
    Protocol: #{request.protocol}
    Host:     #{request.host}
    Port:     #{request.port}
    Origin:   #{request.origin}
    Accept:   #{request.encoding},#{request.accept};#{request.language}"
  end

  def hello_endpoint
    "Hello, World! (#{request.count})"
  end

  def datetime_endpoint
    @status_code = STATUS_CODE[:status_200]
    Date.today.strftime('%I:%M%p on %A, %B %-d, %Y')
  end

  def shutdown_endpoint
    @status_code = STATUS_CODE[:status_200]
    "Total Requests: #{request.count}"
  end

  def word_search_endpoint
    @status_code = STATUS_CODE[:status_200]
    word_search = WordSearch.new
    word_search.search_result(request.parameters)
  end

  def start_game_endpoint
    binding.pry
    return @status_code = STATUS_CODE[:status_403] unless @game.nil?
    @status_code = STATUS_CODE[:status_301]
    # @location = "http://#{request.host}:#{request.port}/game\r\n"
    start_game
  end

  def game_get_endpoint
    return "Start game with a post request to /start_game!" if @game.nil?
    @status_code = STATUS_CODE[:status_200]
    @game.get
  end

  def game_post_endoint
    @status_code = STATUS_CODE[:status_200]
    # @location = "http://#{request.host}:#{request.port}/game\r\n"
    submit_guess
  end

  def force_error
    @status_code = STATUS_CODE[:status_500]
    'ERROR'
  end

  def start_game
    @game = Game.new
    @game.welcome
  end

  def read_guess
    content = current_client.read(request.content_length)
    content.split[-2].to_i
  end

  def submit_guess
    @game.post(read_guess)
  end

  def default_endpoint
    @status_code = STATUS_CODE[:status_404]
  end
end
