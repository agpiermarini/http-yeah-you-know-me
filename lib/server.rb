require 'socket'
require 'pry'
require './lib/request_parser'

class Server
  attr_accessor :client

  def initialize
    @server = TCPServer.new(9292)
  end

  # Method to accept incoming requests
  def start
    @client = @server.accept
    puts "Ready for a request"
    request_lines = []
    while line = client.gets and !line.chomp.empty?   # set up parser class?
        request_lines << line.chomp
    end
    @count += 1
    @request = RequestParser.new(request_lines)
    puts "Got this request:"
    puts request_lines.inspect
    puts @request.debug_info
    response
    start
  end

  def response
    puts "Sending response."
    response = "<pre>" + "Hello, World! (#{@count})" + ("\n") + "</pre>"   #set up response/headers class? formatter essentially?
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
               "server: ruby",
               "content-type: text/html; charset=iso-8859-1",
               "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output
    client.close
  end
end
