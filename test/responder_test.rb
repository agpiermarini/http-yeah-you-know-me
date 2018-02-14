require 'minitest/autorun'
require 'minitest/pride'
require 'Date'
require 'Time'
require './lib/request_parser'
require './lib/responder'
require 'pry'

class ResponderTest < Minitest::Test
  def setup
    @request_1 = ["GET / HTTP/1.1",
                  "Host: 127.0.0.1:9292",
                  "Connection: keep-alive",
                  "Cache-Control: no-cache",
                  "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36",
                  "Postman-Token: 81693efd-e68a-7b84-cb7e-e10bae54b5a7",
                  "Accept: */*",
                  "Accept-Encoding: gzip, deflate, br",
                  "Accept-Language: en-US,en;q=0.9"]

    @request_2 = ["GET /hello HTTP/1.1",
                  "Host: 127.0.0.1:9292",
                  "Connection: keep-alive",
                  "Cache-Control: no-cache",
                  "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36",
                  "Postman-Token: 81693efd-e68a-7b84-cb7e-e10bae54b5a7",
                  "Accept: */*",
                  "Accept-Encoding: gzip, deflate, br",
                  "Accept-Language: en-US,en;q=0.9"]

    @request_3 = ["GET /datetime HTTP/1.1",
                  "Host: 127.0.0.1:9292",
                  "Connection: keep-alive",
                  "Cache-Control: no-cache",
                  "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36",
                  "Postman-Token: 81693efd-e68a-7b84-cb7e-e10bae54b5a7",
                  "Accept: */*",
                  "Accept-Encoding: gzip, deflate, br",
                  "Accept-Language: en-US,en;q=0.9"]

    @request_4 = ["GET /shutdown HTTP/1.1",
                  "Host: 127.0.0.1:9292",
                  "Connection: keep-alive",
                  "Cache-Control: no-cache",
                  "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36",
                  "Postman-Token: 81693efd-e68a-7b84-cb7e-e10bae54b5a7",
                  "Accept: */*",
                  "Accept-Encoding: gzip, deflate, br",
                  "Accept-Language: en-US,en;q=0.9"]

    @request_5 = ["GET /doesnotexist HTTP/1.1",
                  "Host: 127.0.0.1:9292",
                  "Connection: keep-alive",
                  "Cache-Control: no-cache",
                  "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36",
                  "Postman-Token: 81693efd-e68a-7b84-cb7e-e10bae54b5a7",
                  "Accept: */*",
                  "Accept-Encoding: gzip, deflate, br",
                  "Accept-Language: en-US,en;q=0.9"]
  end

  def test_it_exists
    request = RequestParser.new(@request_1)
    responder = Responder.new(request, 1)

    assert_instance_of Responder, responder
  end

  def test_it_handles_no_endpoint
    request = RequestParser.new(@request_1)
    responder = Responder.new(request, 1)


    assert_equal request.debug_info, responder.output
  end

  def test_it_handles_hello_endpoint
    request = RequestParser.new(@request_2)
    responder = Responder.new(request, 1)

    assert_equal "Hello, World! (1)", responder.output
  end

  def test_it_handles_datetime_endpoint
    request = RequestParser.new(@request_3)
    responder = Responder.new(request, 1)
    expected = "#{Date.today.strftime("%I:%M%p on %A, %B %-d, %Y")}"

    assert_equal expected, responder.output
  end

  def test_it_handles_shutdown_endpoint
    request = RequestParser.new(@request_4)
    responder = Responder.new(request, 1)

    assert_equal "Total Requests: 1", responder.output
  end

  def test_it_handles_word_search_endpoint
  end

  def test_it_handles_all_other_endpoints
    request = RequestParser.new(@request_5)
    responder = Responder.new(request, 1)

    assert_equal "401: Not Found :(", responder.output
  end
end
