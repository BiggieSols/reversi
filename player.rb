class Player
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def get_input
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
    (@color == :w) ? "white player" : "black player"
  end
end