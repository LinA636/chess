require_relative "../lib/piece"

class Queen < Piece

  MOVEMENTS =  Array.new(8) {|i| [[0,i], [i,0], [-i, 0], [0, -i], [i, i], [-i, -i], [-i, i], [i, -i]] unless i.zero?}.compact.flatten(1).freeze

  def initialize(color, position)
    if color == :white
      symbol = "\u{2655}"
    elsif color == :black
      symbol = "\u{265B}"
    end
    super(color, symbol, position)
  end

  def next_movements
    super(MOVEMENTS)
  end

  def chosen_destination_reachable?(end_field)
    super(next_movements, end_field)
  end

end