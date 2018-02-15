class Game
  attr_reader :number,
              :total_guesses,
              :last_guess

  def initialize
    @number = rand(0..100)
    @guesses = []
    @last_guess  = 0
  end

  def welcome
    "Good luck!"
  end

  def get
    "Total guesses: #{total_guesses}" + ("\n") +
    "Your last guess was: #{last_guess}, which is #{guess_feedback}"
  end

  def guess_feedback
    return "too high. Guess again!" if last_guess > number
    return "too low. Guess again!"  if last_guess < number
    "correct! Congratulations!"
  end

  def total_guesses
    @guesses.length
  end

  def post(guess = nil)
    @last_guess = guess if !guess.nil?
    @guesses << @last_guess
    "get"
  end
end
