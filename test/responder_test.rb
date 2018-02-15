require 'minitest/autorun'
require 'minitest/pride'
require './lib/request_parser'
require './lib/responder'
require 'faraday'
require 'Date'
require 'pry'

class ResponderTest < Minitest::Test
  def setup
    @debug_info =
    "Verb:    GET
    Path:     /
    Protocol: HTTP/1.1
    Host:     127.0.0.1
    Port:     9292
    Origin:   127.0.0.1
    Accept:   gzip;q=1.0,deflate;q=0.6,identity;q=0.3,*/*"
  end

  def test_it_exists
    skip
    responder = Responder.new(nil)

    assert_instance_of Responder, responder
  end

  def test_it_handles_no_endpoint
    request = Faraday.get "http://127.0.0.1:9292/"

    assert request.body.include?(@debug_info)
  end

  def test_it_handles_hello_endpoint
    request = Faraday.get "http://127.0.0.1:9292/hello"

    assert request.body.include?("Hello, World!")
  end

  def test_it_handles_datetime_endpoint
    request = Faraday.get "http://127.0.0.1:9292/datetime"
    expected = "#{Date.today.strftime("%I:%M%p on %A, %B %-d, %Y")}"

    assert request.body.include?(expected)
  end

  def test_it_handles_word_search_endpoint_with_one_included_word
    request = Faraday.get "http://127.0.0.1:9292/word_search?word=hello"

    assert request.body.include?("HELLO is a known word")
  end

  def test_it_handles_word_search_endpoint_with_one_excluded_word
    request = Faraday.get "http://127.0.0.1:9292/word_search?word=programmin"

    assert request.body.include?("PROGRAMMIN is not a known word")
  end

  def test_it_handles_word_search_endpoint_with_multiple_words
    request = Faraday.get "http://127.0.0.1:9292/word_search?word=hello&word2=concinnity&word3=PROGRAMMIN"

    expected = "HELLO is a known word,\nCONCINNITY is a known word,\nPROGRAMMIN is not a known word"

    assert request.body.include?(expected)
  end

  def test_it_handles_start_game_endpoint
    request = Faraday.post "http://127.0.0.1:9292/start_game"

    assert request.body.include?("Good luck!")
  end

  def test_it_handles_get_game_endpoint
    Faraday.post "http://127.0.0.1:9292/start_game"
    request = Faraday.get "http://127.0.0.1:9292/game"

    assert request.body.include?("Total guesses:")
    assert request.body.include?("Your last guess was:")
  end

  def test_it_handles_all_other_endpoints
    request = Faraday.get "http://127.0.0.1:9292/doesnotexist"

    assert request.body.include?("404: Not Found :(")
  end
end
