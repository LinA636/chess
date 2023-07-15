class Field
  attr_accessor :piece
  attr_reader :color

  def initialize(color, piece = nil)
    @color = color
    @piece = piece
  end
end