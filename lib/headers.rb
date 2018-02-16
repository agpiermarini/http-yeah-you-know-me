  require 'socket'
  require 'Date'
  require './lib/request_parser'
  require './lib/word_search'
  require './lib/game'
  require 'pry'

  class Responder
    include StatusCodes
    attr_reader :path,
                :verb,
                :server,
                :request,
                :client,
                :status_code,
                :location

    def initialize(server)
      @server = server
      @request = server.request
      @client = server.client
      @status_code = nil
      @location = nil
      @game = nil
    end

    def endpoint_map
      {
        "GET/" => :debug_endpoint,
        "POST/" => :debug_endpoint,
        "GET/hello" => :hello_endpoint,
        "GET/datetime" => :datetime_endpoint,
        "GET/shutdown" => :shutdown_endpoint,
        "GET/word_search" => :word_search_endpoint,
        "GET/game" => :get_game_endpoint,
        "POST/game" => :post_game_endoint,
        "POST/start_game" => :start_game_endpoint,
        "POST/force_error" => :force_error,
        "GET/force_error" => :force_error}
      endpoint_map.default = :default_endpoint
    end

    def select_endpoint
      send(endpoint_map[request.verb_path])
    end

    def debug_endpoint
      status_code = status_200
      ("\n") + ("\t") +
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
      status_code = status_200
      Date.today.strftime("%I:%M%p on %A, %B %-d, %Y")
    end

    def shutdown_endpoint
      status_code = status_200
      "Total Requests: #{request.count}"
    end

    def word_search_endpoint
      status_code = status_200
      word_search = WordSearch.new
      word_search.search_result(request.parameters)
    end

    def start_game_endpoint
      if game.nil?
        status_code = status_301
        location = "http://#{@host}:#{@port}#{@path}\r\n"
        start_game
      else
        status_code = status_403
        "403 Forbidden"
      end
    end

    def get_game_endpoint
      status_code = status_200
      @game.get
    end

    def post_game_endoint
      status_code = status_200
      location = "http://#{@host}:#{@port}#{@path}\r\n"
      submit_guess
    end

    def force_error
      status_code = status_500
    end

    def start_game
      @game = Game.new
      @game.welcome
    end

    def read_guess
      content = client.read(request.content_length)
      content.split[-2].to_i
    end

    def submit_guess
      @game.post(read_guess)
    end

    def default_endpoint
      status_code = status_404
    end

# move back to server
headers = ["http/1.1 #{responder.status_code}",
         reponder.location,
         "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
         "server: ruby",
         "content-type: text/html; charset=iso-8859-1",
         "content-length: #{output.length}\r\n\r\n"].join("\r\n")
