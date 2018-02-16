require './test/test_helper'

class ServerTest < Minitest::Test
  def test_it_receives_get_request
    request = Faraday.get 'http://127.0.0.1:9292/'

    refute request.body.empty?
  end

  def test_it_receives_post_request
    request = Faraday.post 'http://127.0.0.1:9292/'

    refute request.body.empty?
  end
end
