require './lib/server.rb'

server = Server.new
server.request_loop
