require_relative "../lib/field"
require_relative "../lib/pawn"
require_relative "../lib/rook"
require_relative "../lib/knight"
require_relative "../lib/bishop"
require_relative "../lib/queen"
require_relative "../lib/king"
require "matrix"

class ChessBoard
  attr_accessor :board
  def initialize
    @board = Matrix.build(8,8).each_with_index {|el, row, col| Field.new("#{get_number_to_letter_hash["#{col}"]}#{8-row}")} 
    setup_board
  end

  def print_board
    puts "  ---------------------------------"
    self.board.row_vectors.each_with_index do |row, row_index|
      print "#{row_index} "
      row.to_a.each do |field|
        print "| #{field.to_s} "
      end
      puts "|"
      puts "  ---------------------------------"
    end
    puts "    a   b   c   d   e   f   g   h  "
  end

  def occupies_piece?(field)
    !field.piece.nil?
  end

  def valid_start_field?(start_field, current_player)
    unless occupies_cp_piece?(start_field, current_player)
      puts "Pick one of YOUR figures: "
      return false
    end
    return true
  end

  def occupies_cp_piece?(field, current_player) #cp: current_player
    unless field.piece.nil?
      return field.piece.color == current_player.color
    end
    return false
  end

  def end_destination_reachable?(end_destination)
    #check if end_destination if reachable by chosen piece (are other pieces in the way?)
    #if not: Pick other desttination!
  end

  def move_piece(start_field, end_field)
    if occuppies_piece?(end_field)
      unless occuppies_cp_piece?(end_field)
        #update field
        #mark piece as captured
      end
    end
    # update start and end_field
  end

  def victory?
    # king in checkmate
    # king captured
    check?
    checkmate?
    king_captured?
  end

  private
  def get_number_to_letter_hash
    letters = ('a'..'h').to_a
    numbers = (0..7).to_a.map(&:to_s)
    numbers.zip(letters).to_h
  end

  def setup_board
    self.board.row(0).each_with_index{|field, column| field.piece = Pawn.new(:black,[0,column])}
    self.board.row(1).each_with_index do |field, column| 
      case column
      when 0, 7
        field.piece = Rook.new(:black, [1,column])
      when 1, 6
        field.piece = Knight.new(:black, [1,column])
      when 2, 5
        field.piece = Bishop.new(:black, [1,column])
      when 3
        field.piece = Queen.new(:black, [1,column])
      when 4
        field.piece = King.new(:black, [1,column])
      end
    end

    self.board.row(6).each_with_index do |field, column| 
      case column
      when 0, 7
        field.piece = Rook.new(:white, [1,column])
      when 1, 6
        field.piece = Knight.new(:white, [1,column])
      when 2, 5
        field.piece = Bishop.new(:white, [1,column])
      when 3
        field.piece = Queen.new(:white, [1,column])
      when 4
        field.piece = King.new(:white, [1,column])
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

  def get_field(destination_pattern)
    self.board.select {|field| field.id == destination_pattern}
  end

  def checkmate?
    
  end

  def check?

  end

  def king_captured?

  end
end