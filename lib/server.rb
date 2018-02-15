require 'socket'
require 'pry'
require './lib/request_parser'
require './lib/responder'

class Server
  attr_reader :server,
              :request,
              :responder

  attr_accessor :client

  def initialize
    @server = TCPServer.new(9292)
    @request = RequestParser.new
    @responder = Responder.new(self)        # passing the requestparser object to gain access to methods in responder...is there a better way?
  end

  def start
    puts "Awaiting request..."
    request_lines = []
    @client = server.accept
    while line = client.gets and !line.chomp.empty?
        request_lines << line.chomp
    end
    request.parse_all(request_lines)
    # binding.pry
    puts "Got this request:\n\n#{request_lines.inspect}\n\n"
    response
    start if request.path != "/shutdown"
  end

  def response
    responder.endpoint
    puts "Sending response.\n"
    response = "<pre>" + "#{responder.endpoint}" + "<pre>"
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
               "server: ruby",
               "content-type: text/html; charset=iso-8859-1",
               "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output
    client.close #unless game is not nil? should i keep cycle open?
  end
end
