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

end