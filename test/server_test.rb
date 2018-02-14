require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'faraday'
require 'socket'

class ServerTest < Minitest::Test
  def test_it_forms_response
    response = Faraday.get "http://127.0.0.1:9292/"

    refute response.body.empty?
  end

end
