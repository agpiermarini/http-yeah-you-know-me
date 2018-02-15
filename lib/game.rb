class Game
  attr_reader :number,
              :guess_counter,
              :previous_guess

  def initialize
    @number = rand(0..100)
    @previous_guess = 0
    @guess_counter = 0
  end

  def welcome
    "Good luck!"
  end

  def get
    # return "You haven't guessed yet!" if guess_counter == 0
    "Total guesses: #{guess_counter}" + ("\n") +
    "Your last guess was: #{previous_guess}, which is #{evaluate_guess}"
  end

  def evaluate_guess
    return "too high. Guess again!" if previous_guess > number
    return "too low. Guess again!"  if previous_guess < number
    "correct! Congratulations!"
  end

  def post(guess)
    @previous_guess = guess
    @guess_counter += 1
    #REDIRECT????
  end
end
