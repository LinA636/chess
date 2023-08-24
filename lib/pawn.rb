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
      self.color == :white ? super(MOVEMENTS_WHITE) : super(MOVEMENTS_BLACK)
    else
      self.color == :white ? super(MOVEMENTS_WHITE.first) : super(MOVEMENTS_BLACK.first)
    end
  end

  def taking_movements
    movements = (self.color == :white) ? TAKING_MOVEMENTS_WHITE : TAKING_MOVEMENTS_BLACK
    movements.map{|arr| [self.position[0]+arr[0], self.position[1]+arr[1]]}
              .keep_if{|arr| position_on_board?(arr)}
  end

  def taking?(end_field)
    taking_movements.include?(end_field.position)
  end

  def chosen_destination_reachable?(end_field, move_take = " ")
    if move_take == "move"
      super(next_movements, end_field)
    elsif move_take == "take"
      super(taking_movements, end_field)
    else
      super(next_movements + taking_movements, end_field)
    end
  end

  def get_field_positions_on_way(end_field)
    # returns the field positions between current field and end_field
    row_start_field = self.position.first
    row_end_field = end_field.position.first
    if self.color == :white
      next_movements.select {|array| (row_start_field > array.first && array.first > row_end_field)}
    elsif self.color == :black
      next_movements.select {|array| (row_start_field < array.first && array.first < row_end_field)}
    end
  end
end