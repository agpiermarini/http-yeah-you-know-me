class Game
  def initialize
    @number = rand(0..100)
    @count  = 0
    @guess  = nil
  end

  def welcome
    "Good luck!"
  end
end
