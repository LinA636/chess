require_relative "../lib/piece"

class Rook < Piece

  attr_accessor :first_move_done

  MOVEMENTS =  Array.new(8) {|i| [[0,i], [i,0], [-i, 0], [0, -i]] unless i.zero?}.compact.flatten(1).freeze

  def initialize(color, position)
    if color == :white
      symbol = "\u{2656}"
    elsif color == :black
      symbol = "\u{265C}"
    end
    super(color, symbol, position)
    @first_move_done = false
  end

  def next_movements
    super(MOVEMENTS)
  end

  def chosen_destination_reachable?(end_field)
    super(next_movements, end_field)
  end

end