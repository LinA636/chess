class Field
  attr_accessor :piece
  attr_reader :id, :position

  def initialize(id, position)
    @id = id
    @position = position
    @piece = nil
  end

  def to_s
    self.piece.nil? ? " " : self.piece
  end

end