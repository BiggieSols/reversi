require_relative 'board'
require_relative 'player'
require_relative 'human_player'
require_relative 'computer_player'

class Reversi

  attr_accessor :board

  def initialize
    @board = Board.new

    @player_1 = ComputerPlayer.new(:w, @board)
    @player_2 = ComputerPlayer.new(:b, @board)

    @current_player = @player_1
  end

  def curr_player_color
    @current_player.color
  end

  def switch_player
    @current_player = (@current_player == @player_1) ? @player_2 : @player_1
  end

  def play
    @board.render(curr_player_color)
    until @board.over?
      begin
        # switch_player if no_current_moves?

        input_coord = @current_player.get_input

        break if input_coord == "exit"

        input_coord = [input_coord[0], input_coord[1]]
        @board.move(input_coord, curr_player_color)

      rescue ArgumentError, RuntimeError, InvalidMoveError => e
        puts e.message
        retry
      end
      switch_player
      
      @board.render(curr_player_color, input_coord)
    end
    @board.render

    output_game_result
  end

  def no_current_moves?
    @board.no_available_moves?(curr_player_color)
  end

  def output_game_result
    if ! @board.over?
      puts "exited game successfully"
    elsif @board.tied?
      puts "it's a tie!"
    else 
      puts "#{@board.winner} won the game!"
    end
  end
end

r = Reversi.new
r.play