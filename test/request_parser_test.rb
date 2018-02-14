require 'minitest/autorun'
require 'minitest/pride'
require './lib/request_parser'
require 'pry'

class RequestParserTest < Minitest::Test
  def setup
    @get_request = ["GET / HTTP/1.1",
                    "Host: 127.0.0.1:9292",
                    "Connection: keep-alive",
                    "Cache-Control: no-cache",
                    "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36",
                    "Postman-Token: 81693efd-e68a-7b84-cb7e-e10bae54b5a7",
                    "Accept: */*",
                    "Accept-Encoding: gzip, deflate, br",
                    "Accept-Language: en-US,en;q=0.9"]

    @post_request = ["POST / HTTP/1.1",
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

    @search_request = ["GET /word_search?word=hello&word2=goodbye HTTP/1.1",
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
  end

  def test_it_receives_get_request
    parser = RequestParser.new(@get_request)

    assert_equal "GET", parser.verb
    assert_equal "/", parser.path
    assert_equal "HTTP/1.1", parser.protocol
    assert_equal "127.0.0.1", parser.host
    assert_equal "9292", parser.port
    assert_equal "127.0.0.1", parser.origin
    assert_equal "gzip, deflate, br", parser.accept_encoding
    assert_equal "*/*", parser.accept
    assert_equal "en-US,en;q=0.9", parser.accept_language
  end

  def test_it_receives_post_request
    parser = RequestParser.new(@post_request)

    assert_equal "POST", parser.verb
    assert_equal "/", parser.path
    assert_equal "HTTP/1.1", parser.protocol
    assert_equal "127.0.0.1", parser.host
    assert_equal "9292", parser.port
    assert_equal "chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop", parser.origin
    assert_equal "gzip, deflate, br", parser.accept_encoding
    assert_equal "*/*", parser.accept
    assert_equal "en-US,en;q=0.9", parser.accept_language
  end

  def test_it_prints_debug_information_get
    parser = RequestParser.new(@get_request)

    expected = "</pre>" + ("\n") + ("\t") +
    "Verb:    GET
    Path:     /
    Protocol: HTTP/1.1
    Host:     127.0.0.1
    Port:     9292
    Origin:   127.0.0.1
    Accept:   gzip, deflate, br,*/*;en-US,en;q=0.9" +
    "</pre>"

     assert_equal expected, parser.debug_info
  end

  def test_it_prints_debug_information_post
    parser = RequestParser.new(@post_request)
    binding.pry
    expected = "</pre>" + ("\n") + ("\t") +
    "Verb:    POST
    Path:     /
    Protocol: HTTP/1.1
    Host:     127.0.0.1
    Port:     9292
    Origin:   chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop
    Accept:   gzip, deflate, br,*/*;en-US,en;q=0.9" +
    "</pre>"

     assert_equal expected, parser.debug_info
  end

  def test_it_isolates_parameters #delete this test if keeping path/param variable setting function in initialize
    parser = RequestParser.new(@search_request)

    assert_equal "word=hello&word2=goodbye", parser.parameters
  end

  def test_it_parses_parameters
    parser = RequestParser.new(@search_request)
    expected = [["word", "hello"], ["word2", "goodbye"]]

    assert_equal expected, parser.parse_parameters
  end
end
