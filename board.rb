# encoding: utf-8
require_relative 'piece'
require 'colorize'

class InvalidMoveError < StandardError
end

class Board
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    set_up_board
  end

  def set_up_board
    self[3, 3] = Piece.new(self, [3, 3], :w)
    self[4, 4] = Piece.new(self, [4, 4], :w)

    self[4, 3] = Piece.new(self, [4, 3], :b)
    self[3, 4] = Piece.new(self, [3, 4], :b)
  end

  def dup
    new_board = Board.new
    (all_pieces(:w) + all_pieces(:b)).each do |piece|
      position = piece.position
      new_piece = Piece.new(new_board, position, piece.color)
      new_board[position[0], position[1]] = new_piece
    end
    new_board
  end

  def move(new_coord, color)

    unless all_available_moves(color).include?(new_coord)
      raise InvalidMoveError.new("you can't go there!")
    end


    new_piece = Piece.new(self, new_coord, color)
    add_piece(new_piece)
  end

  # def winner
  # end

  def add_piece(new_piece)
    color = new_piece.color
    new_position = new_piece.position

    all_pieces(color).each do |piece|
      if piece.has_move?(new_position)
        flip_in_between(piece, new_piece)
      end
    end

    self[new_position[0], new_position[1]] = new_piece
  end

  def flip_in_between(piece1, piece2)
    between_coords(piece1, piece2).each do |coord|
      self[ coord[0], coord[1] ].color = piece1.color
    end
  end

  def between_coords(piece1, piece2)
    first_pos   = piece1.position.dup
    second_pos  = piece2.position.dup

    row_offset = ( second_pos[0] - first_pos[0] ) <=> 0
    col_offset = ( second_pos[1] - first_pos[1] ) <=> 0

    first_pos[0] += row_offset
    first_pos[1] += col_offset

    [].tap do |arr|
      until first_pos == second_pos
        arr << first_pos.dup
        first_pos[0] += row_offset
        first_pos[1] += col_offset
      end
    end
  end

  def clear_screen
    puts "\e[H\e[2J"
  end

  def render(color = nil, last_move = nil, pointer_position = nil)
    clear_screen
    avail_moves = all_available_moves(color)

    puts "  0 1 2 3 4 5 6 7"
    8.times do |row_index|
      print "#{row_index} "
      8.times do |col_index|

        background = ((row_index + col_index) % 2 == 0) ? :light_blue : :light_green
        background = :red if avail_moves.include?( [row_index, col_index] )
        background = :light_white if [row_index, col_index] == last_move
        background = :black if [row_index, col_index] == pointer_position
        piece = self[row_index, col_index]
        to_print = piece.nil? ? "  " : piece.to_s
        print to_print.colorize(background: background)
      end
      puts
    end
  end

  def over?
    no_available_moves? || out_of_pieces?
  end

  def tied?
    num_pieces(:b) == num_pieces(:w)
  end

  def winner
    return :b if num_pieces(:b) > num_pieces(:w)
    :w
  end

  def other_color(color)
    color == :w ? :b : :w
  end

  def all_available_moves(player_color = nil)
    colors = [:w, :b] if player_color == nil
    colors = [player_color] if player_color != nil


    [].tap do |arr|
      colors.each do |color|
        all_pieces(color).each do |piece|
          piece.available_moves.each do |move|
            arr << move
          end
        end
      end
    end
  end

  def no_available_moves?(color = nil)
    all_available_moves(color).empty?
  end

  def all_pieces(color)
    @grid.flatten.compact.select { |piece| piece.color == color }
  end

  def num_pieces(color)
    all_pieces(color).length
  end

  def out_of_pieces?(player_color = nil)
    return (all_pieces(:w) + all_pieces(:b)).empty? if player_color == nil
    all_pieces(:player_color).empty?
  end

  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, piece)
    @grid[row][col] = piece
  end

end