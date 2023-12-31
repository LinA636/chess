require_relative "../lib/piece"

class Knight < Piece

  MOVEMENTS = [[-2,-1], [-2,1], [-1,-2], [-1,2], 
              [1,-2], [1,2], [2,-1], [2,1]].freeze

  def initialize(color, position)
    if color == :white
      symbol = "\u{2658}"
    elsif color == :black
      symbol = "\u{265E}"
    end
    super(color, symbol, position)
  end

  def next_movements
    super(MOVEMENTS)
  end

  def chosen_destination_reachable?(end_field, take_move = " ")
    super(next_movements, end_field)
  end

  def get_field_positions_on_way(end_field)
    []
  end

end