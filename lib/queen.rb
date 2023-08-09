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

  def get_field_positions_on_way(end_field)
    row_start = self.position.first
    column_start = self.position.last
    row_end = end_field.position.first
    column_end = end_field.position.last
    if (row_start == row_end && column_start < column_end)
      # queen is moving horizontally to the right
      return next_movements.select {|array| (array.first == row_start && array.last > column_start && array.last < column_end)}      
    elsif (row_start < row_end && column_start < column_end)
      # queen is moving diagonally down to the right
      return next_movements.select {|array| (array.last > column_start && array.first > row_start && row_end > array.first)}
    elsif (row_start < row_end && column_start == column_end)
      # queen is moving vertically down
      return next_movements.select {|array| (array.last == column_start && row_start < array.first && array.first < row_end)}
    elsif (row_start < row_end && column_start > column_end)
      # queen is moving diagonally down to the left
      return next_movements.select {|array| (array.last < column_start && array.first > row_start && row_end > array.first)}
    elsif (row_start == row_end && column_start > column_end)
      # queen is moving horizontally to the left
      return next_movements.select {|array| (array.first == row_start && column_end < array.last && array.last < column_start)}
    elsif (row_start > row_end && column_start > column_end)
      # queen is moving diagonally up to the left
      return next_movements.select {|array| (array.first < row_start && column_start > array.last && array.last > column_end)}
    elsif (row_start > row_end && column_start == column_end)
      # queen is moving vertically up
      return next_movements.select {|array| (array.last == column_start && row_end < array.first && array.first < row_start)}
    elsif (row_start > row_end && column_start < column_end)
      # queen is moving diagonally up to the right
      return next_movements.select {|array| (array.first < row_start && column_end > array.last && array.last > column_start)}
    end
  end

end