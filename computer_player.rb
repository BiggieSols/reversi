require_relative 'player'

class ComputerPlayer < Player
  attr_reader :color, :board

  def initialize(color, board)
    super(color)
    @board = board
  end

  def get_best_move
    all_moves = @board.all_available_moves(@color)
    corners = available_corners(all_moves)

    return corners.sample unless corners.empty?

    best_move = nil
    max_pieces = 0

    all_moves.each do |move|
      dup_board = @board.dup
      dup_board.move(move, @color)
      num_pieces = dup_board.all_pieces(@color).length
      if num_pieces > max_pieces
        max_pieces = num_pieces
        best_move = move
      end
    end
    puts "done testing dup board"
    best_move
  end

  def available_corners(moves)
    corners = [ [0, 0], [0, 7], [7, 0], [7, 7] ]
    moves.select { |move| corners.include? (move) }
  end

  def get_input
    get_best_move
  end

  def player_name
    (@color == :w) ? "white player" : "black player"
  end
end