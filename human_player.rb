require 'io/console'
require_relative 'player'

class HumanPlayer < Player
  def get_input
    pointer_pos = [0, 0]
    @board.render(@color, nil, pointer_pos)
    
    while true
      char = STDIN.getch.to_s
      if char == "D"
        pointer_pos[1] -= 1 if pointer_pos[1] > 0
        @board.render(@color, nil, pointer_pos)
      elsif char == "C"
        pointer_pos[1] += 1 if pointer_pos[1] < 7
        @board.render(@color, nil, pointer_pos)
      elsif char == "A"
        pointer_pos[0] -= 1 if pointer_pos[0] > 0
        @board.render(@color, nil, pointer_pos)
      elsif char == "B"
        pointer_pos[0] += 1 if pointer_pos[0] < 7
        @board.render(@color, nil, pointer_pos)
      elsif char == "\r"
        puts "chosen position is #{pointer_pos}"
        return pointer_pos
      end
      
      return "exit" if char == "q"
    end
  end
end

