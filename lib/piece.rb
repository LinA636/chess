require_relative "../lib/field"

class Piece
  attr_accessor :children, :parent, :position, :captured
  attr_reader :symbol, :color

  def initialize(color, symbol, position, parent = nil)
    @children = []
    @symbol = symbol
    @color = color
    @parent = parent
    @position = position
    @captured = false
  end

  private
  def position_on_board?(arr)
    arr[0].between?(0,7) && arr[1].between?(0,7)
  end

  def next_movements(movements)
    if movements[0].instance_of?(Array)
      movements.map{|arr| [self.position[0]+arr[0], self.position[1]+arr[1]]}
             .keep_if{|arr| position_on_board?(arr)} 
    else
      [self.position[0]+movements[0], self.position[1]+movements[1]].keep_if{|arr| position_on_board?(arr)}
    end
  end

  def to_s
    self.symbol
  end

  def chosen_destination_reachable?(movements, end_field)
    if movements.include?(end_field.position)
      return true
    end
    puts "Choose reachable destination: "
    false
  end

end