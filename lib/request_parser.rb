require 'pry'

class RequestParser
  def initialize(request_lines)
    @verb =
    @path =
    @protocol =
    @host =
    @port =
    @origin =
    @accept =
  end

  # find what is common to all verbs and parse at initialize
  # remainder parsed in methods below...if statements, case statements?

end
