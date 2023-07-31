#require_relative "../lib/piece"
#require_relative "../lib/pawn"
#require_relative "../lib/rook"
#require_relative "../lib/knight"
#require_relative "../lib/bishop"
#require_relative "../lib/king"
#require_relative "../lib/queen"

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
    unless empty?()
      return self.piece.color == current_player.color
    end
    return false
  end

  def occupies_opponent_piece?(current_player)
    unless empty?()
      return self.piece.color != current_player.color
    end
    return false
  end

  def empty?
    self.piece.nil?
  end

end