require_relative 'board'

class Reversi

  attr_accessor :board

  def initialize
    @board = Board.new
    @player_color = :w
  end

  def switch_player
    @player_color = @board.other_color(@player_color)
  end

  def play
    until @board.over?(@player_color)
      begin
        input_coord = get_input

        break if input_coord == "exit"

        input_coord = [input_coord[0], input_coord[1]]
        @board.move(input_coord, @player_color)
      rescue Exception => e
        puts e.message
        retry
      end

      switch_player

    end
    @board.render(@player_color)
    puts "game over!"
  end

  def get_input
    @board.render(@player_color)
    puts "#{player_name} see avialable moves above"
    puts "please enter your move coordinates"
    input = parse_input(gets.chomp)
  end

  def parse_input(input)
    return "exit" if input == "exit"
    raise "invalid input, must enter coord, coord" unless input =~ /^\s*[0-9],?\s*[0-9]\s*$/
    input_arr = input.split(/,?\s*/).map(&:to_i)
  end

  def player_name
    (@player_color == :w) ? "white player" : "black player"
  end
end

r = Reversi.new
r.play