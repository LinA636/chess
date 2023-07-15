require "matrix"

class ChessBoard
  def initialize
    @grid = Matrix.build(8,8){Field.new}
    setup_board
  end

  def setup_board
    # Initialize the board with pieces
    # ...
  end

  def move(from, to)
    # Move the piece on the board
    # ...
  end

  def valid_move?(from, to, color)
    # Check if the move is valid for the specified color
    # ...
  end

  def print_board
    puts "  a b c d e f g h"
    @grid.each_with_index do |row, i|
      print "#{8 - i} "
      row.each { |piece| print "#{piece} " }
      puts
    end
  end

  def checkmate?(color)
    # Check if the specified color is in checkmate
    # ...
  end
end