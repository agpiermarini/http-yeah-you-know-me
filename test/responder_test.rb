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

    @request_4 = ["GET /word_search?word=hello HTTP/1.1",
                  "Host: 127.0.0.1:9292",
                  "Connection: keep-alive",
                  "Content-Length: 0",
                  "Cache-Control: no-cache",
                  "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
                  "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36",
                  "Postman-Token: 76f1ee57-3393-3121-185a-7e9176c3fbfb",
                  "Accept: */*",
                  "Accept-Encoding: gzip, deflate, br",
                  "Accept-Language: en-US,en;q=0.9"]

    @request_5 = ["GET /word_search?word=programmin HTTP/1.1",
                  "Host: 127.0.0.1:9292",
                  "Connection: keep-alive",
                  "Content-Length: 0",
                  "Cache-Control: no-cache",
                  "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
                  "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36",
                  "Postman-Token: 76f1ee57-3393-3121-185a-7e9176c3fbfb",
                  "Accept: */*",
                  "Accept-Encoding: gzip, deflate, br",
                  "Accept-Language: en-US,en;q=0.9"]

    @request_6 = ["GET /word_search?word=hello&word2=concinnity&word3=programmin HTTP/1.1",
                  "Host: 127.0.0.1:9292",
                  "Connection: keep-alive",
                  "Content-Length: 0",
                  "Cache-Control: no-cache",
                  "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
                  "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36",
                  "Postman-Token: 76f1ee57-3393-3121-185a-7e9176c3fbfb",
                  "Accept: */*",
                  "Accept-Encoding: gzip, deflate, br",
                  "Accept-Language: en-US,en;q=0.9"]

    @request_7 = ["GET /shutdown HTTP/1.1",
                  "Host: 127.0.0.1:9292",
                  "Connection: keep-alive",
                  "Cache-Control: no-cache",
                  "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36",
                  "Postman-Token: 81693efd-e68a-7b84-cb7e-e10bae54b5a7",
                  "Accept: */*",
                  "Accept-Encoding: gzip, deflate, br",
                  "Accept-Language: en-US,en;q=0.9"]

    @request_8 = ["GET /start_game HTTP/1.1",
                  "Host: 127.0.0.1:9292",
                  "Connection: keep-alive",
                  "Cache-Control: no-cache",
                  "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36",
                  "Postman-Token: 81693efd-e68a-7b84-cb7e-e10bae54b5a7",
                  "Accept: */*",
                  "Accept-Encoding: gzip, deflate, br",
                  "Accept-Language: en-US,en;q=0.9"]

    @request_9 = ["GET /doesnotexist HTTP/1.1",
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


    assert_equal request.debug_info, responder.endpoint
  end

  def test_it_handles_hello_endpoint
    request = RequestParser.new(@request_2)
    responder = Responder.new(request, 1)

    assert_equal "Hello, World! (1)", responder.endpoint
  end

  def test_it_handles_datetime_endpoint
    request = RequestParser.new(@request_3)
    responder = Responder.new(request, 1)
    expected = "#{Date.today.strftime("%I:%M%p on %A, %B %-d, %Y")}"

    assert_equal expected, responder.endpoint
  end

  def test_it_handles_word_search_endpoint_with_one_included_word
    request = RequestParser.new(@request_4)
    responder = Responder.new(request, 1)
    expected = "HELLO is a known word"

    assert_equal expected, responder.endpoint
  end

  def test_it_handles_word_search_endpoint_with_one_excluded_word
    request = RequestParser.new(@request_5)
    responder = Responder.new(request, 1)
    expected = "PROGRAMMIN is not a known word"

    assert_equal expected, responder.endpoint
  end

  def test_it_handles_word_search_endpoint_with_multiple_words
    request = RequestParser.new(@request_6)
    responder = Responder.new(request, 1)
    expected = "HELLO is a known word,\nCONCINNITY is a known word,\nPROGRAMMIN is not a known word"

    assert_equal expected, responder.endpoint
  end

  def test_it_handles_shutdown_endpoint
    request = RequestParser.new(@request_7)
    responder = Responder.new(request, 1)

    assert_equal "Total Requests: 1", responder.endpoint
  end

  def test_it_handles_start_game_endpoint
    request = RequestParser.new(@request_8)
    responder = Responder.new(request, 1)

    assert_equal "Good luck!", responder.endpoint
  end

  def test_it_handles_all_other_endpoints
    request = RequestParser.new(@request_9)
    responder = Responder.new(request, 1)

    assert_equal "404: Not Found :(", responder.endpoint
  end
end
