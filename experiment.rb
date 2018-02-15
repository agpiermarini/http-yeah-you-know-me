require 'socket'
require 'pry'

tcp_server = TCPServer.new(9292)
client = tcp_server.accept

puts "Ready for a request"
request_lines = []
count = 0
while line = client.gets and !line.chomp.empty?
  request_lines << line.chomp
  binding.pry
  count += 1
end

puts "Got this request:"
puts request_lines.inspect

puts "Sending response."
response = "<pre>" + "Hello, World (#{count})" + ("\n") + "</pre>"
output = "<html><head></head><body>#{response}</body></html>"
headers = ["http/1.1 200 ok",
           "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
           "server: ruby",
           "content-type: text/html; charset=iso-8859-1",
           "content-length: #{output.length}\r\n\r\n"].join("\r\n")
client.puts headers
client.puts output

puts ["Wrote this response:", headers, output].join("\n")
#client.close
puts "\nResponse complete, exiting."



# instead of case statement...
# def call_some_method(method)
#   "somethin_typed"
#   # method will be a string
#   method_name = method.to_sym
#   self.send(method_name)
#   o = Object.new
#   o.send(:some_method)
#   o.some_method
#   # above are equivalent
#
#   current_user.username
#   current_user.try(:username)
# end
#
# def endpoint
#   return not_found if !endpoint_map[path]
#   self.send(endpoint_map[path])
#   self.send(:method_name) #symbol method
# endpoint_map[path].call # lambda if instead of symbol, ->
# end
