require_relative "../lib/piece"

class Bishop < Piece

  MOVEMENTS = Array.new(8) {|i| [[i, i], [-i, -i], [-i, i], [i, -i]] unless i.zero?}.compact.flatten(1).freeze

  def initialize(color, position)
    if color == :white
      symbol = "\u{2657}"
    elsif color == :black
      symbol = "\u{265D}"
    end
    super(color, symbol, position)
  end


  def next_movements
    super(MOVEMENTS)
  end

end