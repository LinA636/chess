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

  def get_field_positions_on_way(end_field)
    row_start = self.position.first
    column_start = self.position.last
    row_end = end_field.position.first
    column_end = end_field.position.last
    if row_start == row_end
      # rook is moving horizontally
      if column_start < column_end
        # end_field is right from start_field
        return next_movements.select {|array| (array.first == row_start && column_start < array.last && array.last < column_end)}
      elsif column_end < column_start
        # end_field is left from start_field
        return next_movements.select {|array| (array.first == row_start && column_end < array.last && array.last < column_start)}
      end
    elsif column_start == column_end
      # rook is moving vertically
      if row_end < row_start
        # end_field is above start_field
        return next_movements.select {|array| (array.last == column_start && row_end < array.first && array.first < row_start)}
      elsif row_start < row_end
        # end_field is underneath start_field
        return next_movements.select {|array| (array.last == column_start && row_start < array.first && array.first < row_end)}
      end
    end
  end

end