require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'faraday'
require 'socket'

class ServerTest < Minitest::Test
  def test_it_GETs
    request = Faraday.get "http://127.0.0.1:9292/"

    assert request.body.include?("GET")
  end

end
