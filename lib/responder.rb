require './lib/endpoints'
require './lib/status_codes'
require './lib/request_parser'
require './lib/word_search'
require './lib/game'
require 'socket'
require 'Date'
require 'pry'

class Responder
  include StatusCodes
  include Endpoints
  attr_reader :path,
              :verb,
              :server,
              :status_code,
              :location

  def initialize(server)
    @server = server
    @status_code = nil
    @location = nil
    @game = nil
  end

  def request
    server.request
  end

  def current_client
    server.client
  end

  def select_endpoint
    return default_endpoint unless ENDPOINT_MAP[verb_path]
    send(ENDPOINT_MAP[verb_path])
  end

  def verb_path
    request.verb + request.path
  end

  def debug_endpoint
    @status_code = STATUS_CODE[:status_200]
    "Verb:  #{request.verb}\nPath:  #{request.path}\nProtocol: #{request.protocol}\nHost:     #{request.host}\nPort:     #{request.port}\nOrigin:   #{request.origin}\nAccept:   #{request.encoding},#{request.accept};#{request.language}"
  end

  def hello_endpoint
    @status_code = STATUS_CODE[:status_200]
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
    return @status_code = STATUS_CODE[:status_403] unless @game.nil?
    @status_code = STATUS_CODE[:status_301]
    @location = "location: http://#{request.host}:#{request.port}/game"
    start_game
  end

  def game_get_endpoint
    return "You haven't started a game yet!" if @game.nil?
    @status_code = STATUS_CODE[:status_200]
    @game.get
  end

  def game_post_endoint
    return "You haven't started a game yet!" if @game.nil?
    @status_code = STATUS_CODE[:status_302]
    @location = "Location: http://#{request.host}:#{request.port}/game"
    submit_guess
  end

  def force_error
    @status_code = STATUS_CODE[:status_500]
    raise_exception
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

  def raise_exception
    raise 'Something terrible has happened!'
  rescue StandardError => exception
    exception.backtrace.join("\n")
    # raise
  end

  def new_game?
    verb_path == "POST/start_game" && @game.guess_counter.zero?
  end

  def game_post?
    verb_path == "POST/game" && !@game.nil?
  end

  def status_location
    if new_game? || game_post?
      "#{@status_code},\n#{@location}"
    else
      "#{@status_code}"
    end
  end
end
