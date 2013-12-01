require 'io/console'
require_relative 'player'

class HumanPlayer < Player
  attr_accessor :last_move

  def initialize(color, board)
    super(color, board)
    @last_move = nil
  end

  def get_input
    pointer_pos = last_move || [0, 0]
    @board.render(@color, nil, pointer_pos)
    
    while true
      char = STDIN.getch.to_s
      
      case char
      when "D"
        pointer_pos = move_pointer(pointer_pos, :left)
      when "C"
        pointer_pos = move_pointer(pointer_pos, :right)
      when "A"
        pointer_pos = move_pointer(pointer_pos, :up)
      when "B"
        pointer_pos = move_pointer(pointer_pos, :down)
      when "\r"
        @last_move = pointer_pos.dup
        return pointer_pos
      when "q"
        return "exit"
      end
    end
  end

  def move_pointer(pointer, direction)
    directions = {
      up:     [-1,  0],
      down:   [ 1,  0],
      left:   [ 0, -1],
      right:  [ 0,  1]
    }
    dir_to_move = directions[direction]
    new_pos = [ pointer[0] + dir_to_move[0], pointer[1] + dir_to_move[1] ]

    return pointer unless in_bounds(new_pos)

    @board.render(@color, nil, new_pos)
    new_pos
  end

  # replace with module later
  def in_bounds(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end
end