require_relative "../lib/piece"

class King < Piece

  attr_accessor :first_move_done

  MOVEMENTS = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1],[1,0],[1,1]]
  
  def initialize(color, position)
    if color == :white
      symbol = "\u{2654}"
    elsif color == :black
      symbol = "\u{265A}"
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

  def get_field_positions_on_way(end_field)
    return nil unless chosen_destination_reachable?(end_field)
    []
  end

end