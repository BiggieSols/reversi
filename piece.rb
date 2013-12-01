# encoding: utf-8

class Piece
  attr_reader :board
  attr_accessor :position, :color

  def initialize(board, position, color)
    @board, @position, @color = board, position, color
  end

  def to_s
    color == :w ? "⚪ " : "⚫ "
  end

  def has_move?(new_coords)
    available_moves.include?(new_coords)
  end

  def has_any_moves?
    !available_moves.empty?
  end

  def available_moves
    avail_moves = []

    valid_offsets.each do |offset|      
      # start by offsetting once
      new_pos = offset_pos(@position, offset)

      while true
        puts
        new_pos = offset_pos(new_pos, offset)

        piece = @board[ new_pos[0], new_pos[1] ]

        break unless in_bounds(new_pos)
        if piece.nil?
          avail_moves << new_pos
          break
        end
      end
    end
    avail_moves
  end

  def valid_offsets
    offsets.select do |offset|
      new_pos = offset_pos(@position, offset)
      piece = @board[ new_pos[0], new_pos[1] ]
      # puts "#{piece} is at position #{new_pos}"

      !piece.nil? && piece.color != @color
    end
  end

  # private

  def offset_pos(pos, offset)
    [ pos[0] + offset[0], pos[1] + offset[1] ]
  end

  def in_bounds(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def offsets
    [].tap do |arr|
      (-1 .. 1).each do |row|
        (-1.. 1).each do |col|
          arr << [ row, col ]
        end
      end
    end
  end
end