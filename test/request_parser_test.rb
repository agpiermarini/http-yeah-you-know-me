require 'minitest/autorun'
require 'minitest/pride'
require './lib/request_parser'
require 'pry'

class RequestParserTest < Minitest::Test
  # def test_it_exists
  #   request = ["GET / HTTP/1.1",
  #               "User-Agent: Faraday v0.14.0",
  #               "Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
  #               "Accept: */*",
  #               "Connection: close",
  #               "Host: 127.0.0.1:9292"]
  #   parser = RequestParser.new(request)
  #
  #   assert_instance_of RequestParser, parser
  # end
  #
  def test_it_receives_get_request
    request = ["GET / HTTP/1.1",
               "Host: 127.0.0.1:9292",
               "Connection: keep-alive",
               "Cache-Control: no-cache",
               "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36",
               "Postman-Token: 81693efd-e68a-7b84-cb7e-e10bae54b5a7",
               "Accept: */*",
               "Accept-Encoding: gzip, deflate, br",
               "Accept-Language: en-US,en;q=0.9"]
    parser = RequestParser.new(request)

    assert_equal "GET", parser.verb
    assert_equal "/", parser.path
    assert_equal "HTTP/1.1", parser.protocol
    assert_equal "127.0.0.1", parser.host
    assert_equal "9292", parser.port
    assert_equal "gzip, deflate, br", parser.accept_encoding
    assert_equal "*/*", parser.accept
    assert_equal "en-US,en;q=0.9", parser.accept_language
  end
end

# GET / HTTP/1.1
# Host: 127.0.0.1:9292
# Connection: keep-alive
# Cache-Control: no-cache
# User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36
# Postman-Token: 526edc09-bd02-14b0-d329-3345daf2a422
# Accept: */*
# Accept-Encoding: gzip, deflate, br
# Accept-Language: en-US,en;q=0.9

# POST / HTTP/1.1
# Host: 127.0.0.1:9292
# Connection: keep-alive
# Content-Length: 0                     # different
# Cache-Control: no-cache
# Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop    # different
# User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36
# Postman-Token: 76f1ee57-3393-3121-185a-7e9176c3fbfb
# Accept: */*
# Accept-Encoding: gzip, deflate, br
# Accept-Language: en-US,en;q=0.9
