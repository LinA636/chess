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
end