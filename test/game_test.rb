require './test/test_helper'
require './lib/game'

class GameTest < Minitest::Test
  def test_it_exists
    game = Game.new

    assert_instance_of Game, game
  end

  def test_it_wishes_user_good_luck
    game = Game.new

    assert_equal 'Good luck!', game.welcome
  end
end
