require_relative "../lib/piece"
class Pawn < Piece
  attr_accessor :first_move_done

  MOVEMENTS_WHITE = [[-1, 0], [-2,0]].freeze
  MOVEMENTS_BLACK = [[1,0], [2,0]].freeze
  TAKING_MOVEMENTS_WHITE = [[-1,1], [-1,-1]].freeze
  TAKING_MOVEMENTS_BLACK = [[1,-1], [1,1]].freeze

  def initialize(color, position)
    if color == :white
      symbol = "\u{2659}"
    elsif color == :black
      symbol = "\u{265F}"
    end
    super(color, symbol, position)
    @first_move_done = false
  end

  def next_movements
    unless first_move_done
      color == :white ? super(MOVEMENTS_WHITE) : super(MOVEMENTS_BLACK)
    else
      color == :white ? super(MOVEMENTS_WHITE.first) : super(MOVEMENTS_BLACK.first)
    end
  end

  def taking_movements
    movements = (color == :white) ? TAKING_MOVEMENTS_WHITE : TAKING_MOVEMENTS_BLACK
    movements.map{|arr| [self.position[0]+arr[0], self.position[1]+arr[1]]}
              .keep_if{|arr| position_on_board?(arr)}
  end
end