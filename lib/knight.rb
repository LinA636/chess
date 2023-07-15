class Knight < Piece

  MOVEMENTS = [[-2,-1], [-2,1], [-1,-2], [-1,2], 
              [1,-2], [1,2], [2,-1], [2,1]].freeze

  def initialize(position, color)
    if color = "white"
      symbol = "\u{2658}"
    elsif color = "black"
      symbol = "\u{265E}"
    end
    super(position, symbol, color)
  end

  def next_movements
    MOVEMENTS.map{|arr| [self.position[0]+arr[0], self.position[1]+arr[1]]}
             .keep_if{|arr| valid_pos?(arr)} 
  end

  def to_s
    "Knight: #{self.position}"
  end

  private
  def valid_pos?(arr)
    arr[0].between?(0,7) && arr[1].between?(0,7)
  end

end