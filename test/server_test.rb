require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'faraday'
require 'socket'

class ServerTest < Minitest::Test
  def test_it_sends_response
    response = Faraday.get "http://127.0.0.1:9292/"

    assert response.body.include?("Hello")
  end

end
