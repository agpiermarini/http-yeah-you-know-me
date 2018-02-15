require 'socket'
require 'pry'
require './lib/request_parser'
require './lib/responder'

class Server
  attr_reader :server,
              :request,
              :responder

  attr_accessor :client,
                :count

  def initialize
    @server = TCPServer.new(9292)
    @request = RequestParser.new
    @count  = 0
  end

  def start
    puts "Awaiting request..."
    request_lines = []
    @client = server.accept
    while line = client.gets and !line.chomp.empty?
        request_lines << line.chomp
    end
    @count += 1
    request.parse_all(request_lines)
    puts "Got this request:\n\n#{request_lines.inspect}\n\n"
    response
    start if request.path != "/shutdown"
  end

  def response
    @responder = Responder.new(request, count)
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
