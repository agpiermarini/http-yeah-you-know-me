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

  def test_it_parses_verb_path_protocol
    parser = RequestParser.new
    parser.parse_verb_path_protocol(@search_request)

    assert_equal "GET", parser.verb
    assert_equal "/word_search", parser.path
    assert_equal "HTTP/1.1", parser.protocol
    assert_equal "word=hello&word2=goodbye", parser.parameters
  end

  def test_it_parses_parameters
    parser = RequestParser.new
    parser.parse_verb_path_protocol(@search_request)
    parser.parse_parameters

    expected = [["word", "hello"], ["word2", "goodbye"]]

    assert_equal expected, parser.parameters
  end

  def test_it_parses_remainder
    parser = RequestParser.new
    parser.parse_verb_path_protocol(@search_request)
    parser.parse_remainder(@search_request)

    assert_equal "127.0.0.1", parser.host
    assert_equal "chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop", parser.origin
    assert_equal "gzip, deflate, br", parser.encoding
    assert_equal "*/*", parser.accept
    assert_equal "en-US,en;q=0.9", parser.language
  end

  def test_it_parses_entire_get_request
    parser = RequestParser.new
    parser.parse_all(@get_request)

    assert_equal "GET", parser.verb
    assert_equal "/", parser.path
    assert_equal "HTTP/1.1", parser.protocol
    assert_equal "127.0.0.1", parser.host
    assert_equal "9292", parser.port
    assert_equal "127.0.0.1", parser.origin
    assert_equal "gzip, deflate, br", parser.encoding
    assert_equal "*/*", parser.accept
    assert_equal "en-US,en;q=0.9", parser.language
  end

  def test_it_parses_entire_post_request
    parser = RequestParser.new
    parser.parse_all(@post_request)

    assert_equal "POST", parser.verb
    assert_equal "/", parser.path
    assert_equal "HTTP/1.1", parser.protocol
    assert_equal "127.0.0.1", parser.host
    assert_equal "9292", parser.port
    assert_equal "chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop", parser.origin
    assert_equal "gzip, deflate, br", parser.encoding
    assert_equal "*/*", parser.accept
    assert_equal "en-US,en;q=0.9", parser.language
  end

  def test_get?
    parser = RequestParser.new
    parser.parse_all(@get_request)

    assert parser.get?
    refute parser.post?
  end

  def test_post?
    parser = RequestParser.new
    parser.parse_all(@post_request)

    assert parser.post?
    refute  parser.get?
  end
end
