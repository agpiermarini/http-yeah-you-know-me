class Game
  attr_reader :number,
              :total_guesses,
              :last_guess

  def initialize
    @number = rand(0..100)
    @total_guesses  = 0
    @last_guess  = 0
  end

  def welcome
    "Good luck!"
  end

  def guess(number)
    @last_guess = number
    @total_guesses += 1
  end

  def get
    "Total guesses: #{total_guesses}" + ("\n")
    "Your last guess was: #{last_guess}, which is #{guess_feedback}"
  end

  def guess_feedback
    return "too high. Guess again!" if last_guess > number
    return "too low. Guess again!"  if last_guess < number
    "correct! Congratulations!"
  end

  def post
  end
end
