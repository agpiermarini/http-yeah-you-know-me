class Game
  attr_reader :number,
              :guess_counter,
              :previous_guess

  def initialize
    @number = rand(0..100)
    @previous_guess = nil
    @guess_counter = 0
  end

  def welcome
    "Good luck!"
  end

  def post(guess)
    @previous_guess = guess
    @guess_counter += 1
  end

  def get
    return "Get guessing!" if guess_counter.zero?
    "#{previous_guess} is #{evaluate_guess}\nTotal guesses: #{guess_counter}"
  end

  def evaluate_guess
    return "too high. Guess again!" if previous_guess > number
    return "too low. Guess again!"  if previous_guess < number
    "correct! Congratulations!"
  end
end
