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

  def chosen_destination_reachable?(end_field)
    super(next_movements, end_field)
  end

  def get_field_positions_on_way(end_field)
    row_start = self.position.first
    column_start = self.position.last
    row_end = end_field.position.first
    column_end = end_field.position.last
    if row_start > row_end
      # bishop is moving diagonal upwards
      if column_start > column_end
        # to the left
        return next_movements.select {|array| (array.first < row_start && column_start > array.last && array.last > column_end)}
      elsif column_start < column_end
        # to the right
        return next_movements.select {|array| (array.first < row_start && column_end > array.last && array.last > column_start)}
      end
    elsif row_start < row_end
      # bishop is moving diagonal downwards
      if column_start > column_end
        # to the left
        return next_movements.select {|array| (array.last < column_start && array.first > row_start && row_end > array.first)}
      elsif column_start < column_end
        # to the right
        return next_movements.select {|array| (array.last > column_start && array.first > row_start && row_end > array.first)}
      end
    end
  end


end