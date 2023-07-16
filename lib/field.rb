class Field
  attr_accessor :piece
  attr_reader :id

  def initialize(id)
    @id = id
    @piece = nil
  end

end