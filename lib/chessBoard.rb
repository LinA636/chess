require "matrix"

class ChessBoard
  attr_accessor :board
  def initialize
    @board = Matrix.build(8,8).each_with_index {|row, col| Field.new([row, col])}
    setup_board
  end



  def setup_board
    self.board.row(0).each_with_index{|field, column| field.piece = Pawn.new(:black,[0,column])}
    self.board.row(1).each_with_index do |field, column| 
      case column
      when 0 || 7
        field.piece = Rook.new(:black, [1,column])
      when 1 || 6
        field.piece = Knight.new(:black, [1,column])
      when 2 || 5
        field.piece = Bishop.new(:black, [1,column]),
      when 3
        field.piece = Queen.new(:black, [1,column])
      when 4
        field.piece = King.new(:black, [1,column])
      end
    end

    self.board.row(6).each_with_index do |field, column| 
      case column
      when 0 || 7
        field.piece = Rook.new(:black, [1,column])
      when 1 || 6
        field.piece = Knight.new(:black, [1,column])
      when 2 || 5
        field.piece = Bishop.new(:black, [1,column]),
      when 3
        field.piece = Queen.new(:black, [1,column])
      when 4
        field.piece = King.new(:black, [1,column])
      end
    end
    
    self.board.row(7).each_with_index{|field, column| field.piece = Pawn.new(:white,[7,column])}
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
    @board.each_with_index do |row, i|
      print "#{8 - i} "
      row.each { |field| print "#{field} " }
      puts
    end
  end

  def checkmate?(color)
    # Check if the specified color is in checkmate
    # ...
  end
end