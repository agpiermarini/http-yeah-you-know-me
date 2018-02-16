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

  def test_number_is_generated_randomly
    game = Game.new
    game2 = Game.new

    refute_equal game.number, game2.number
  end

  def test_it_stores_last_guess
    game = Game.new

    game.post(5)
    assert_equal 5, game.previous_guess

    game.post(6)
    assert_equal 6, game.previous_guess
  end

  def test_it_increments_counter
    game = Game.new
    game.post(5)

    assert_equal 1, game.guess_counter
  end

  def test_it_evaluates_guess
    game = Game.new

    game.post(101)
    assert_equal "too high. Guess again!", game.evaluate_guess

    game.post(-1)
    assert_equal "too low. Guess again!", game.evaluate_guess
  end

  def test_game_returns_string_if_no_guesses
    game = Game.new

    assert_equal "Get guessing!", game.get

    game.post(-1)
    assert_equal "-1 is too low. Guess again!\nTotal guesses: 1", game.get
    game.post(101)
    assert_equal "101 is too high. Guess again!\nTotal guesses: 2", game.get
  end

  def test_it_congratulates_if_guess_correct
    game = Game.new
    number = game.number
    game.post("#{number}".to_i)

    expected = "#{number} is correct! Congratulations!\nTotal guesses: 1"
    assert_equal expected, game.get
  end
end
