class MethodUndefinedError < StandardError
end

class Player
  attr_reader :color

  def initialize(color, board)
    @color, @board = color, board
  end

  def get_input
    raise MethodUndefinedError.new("method not defined for this class")
  end

  def player_name
    (@color == :w) ? "white player" : "black player"
  end
end