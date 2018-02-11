require 'minitest/autorun'
require 'minitest/pride'
require './lib/request_parser'
require 'pry'

class RequestParserTest < Minitest::Test
  def test_it_exists
    parser = RequestParser.new

    assert_instance_of RequestParser, parser
  end
  #
  # def test_it_receives_request
  #   request = Faraday.get "http://127.0.0.1:9292/"
  #   expected = ["GET / HTTP/1.1",
  #               "User-Agent: Faraday v0.14.0",
  #               "Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
  #               "Accept: */*",
  #               "Connection: close",
  #               "Host: 127.0.0.1:9292"]
  #
  #   assert_equal expected, request
  # end
end
