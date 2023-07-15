class Piece
  attr_accessor :children, :parent, :position, :captured?
  attr_reader :symbol, :color

  def initialize(position, symbol, color, parent = nil)
    @children = []
    @symbol = symbol
    @color = color
    @parent = parent
    @position = position
    @captured? = false
  end
end