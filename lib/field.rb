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

  def occupies_piece?
    !self.piece.nil?
  end

  def occupies_cp_piece?(current_player) #cp: current_player
    unless self.piece.nil?
      return self.piece.color == current_player.color
    end
    return false
  end

end