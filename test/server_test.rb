require './test/test_helper'

class ServerTest < Minitest::Test
  def test_it_forms_response
    request = Faraday.get 'http://127.0.0.1:9292/'

    refute request.body.empty?
  end
end
