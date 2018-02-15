class Game
  attr_reader :number,
              :guess_counter,
              :last_guess

  def initialize
    @number = rand(0..100)
    @guess_counter = 0
    @last_guess  = 0
  end

  def welcome
    "Good luck!"
  end

  def get
    # return "You haven't guessed yet!" if guess_counter == 0
    "Total guesses: #{guess_counter}" + ("\n") +
    "Your last guess was: #{last_guess}, which is #{guess_feedback}"
  end

  def guess_feedback
    return "too high. Guess again!" if last_guess > number
    return "too low. Guess again!"  if last_guess < number
    "correct! Congratulations!"
  end

  def post(guess)
    @last_guess = guess
    @guess_counter += 1
  end
end
