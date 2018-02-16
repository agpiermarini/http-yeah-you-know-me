require 'socket'
require './lib/request_parser'
require './lib/responder'
require 'pry'

class Server
  attr_reader :server,
              :request,
              :responder,
              :client

  def initialize
    @server = TCPServer.new(9292)
    @request = RequestParser.new
    @responder = Responder.new(self)
  end

  def request_loop
    puts "Awaiting request..."
    request_lines = []
    @client = server.accept
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request.parse_all(request_lines)
    puts "Got this request:\n\n#{request_lines.inspect}\n\n"
    response
    request_loop if request.path != "/shutdown"
  end

  def response
    response = "<pre>" + "#{responder.select_endpoint}" + "</pre>"
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 #{responder.status_location}",
               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
               "server: ruby",
               "content-type: text/html; charset=iso-8859-1",
               "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    puts "Sent this response:\n\n#{headers}\n\n"
    client.puts headers
    client.puts output
    client.close
  end
end
