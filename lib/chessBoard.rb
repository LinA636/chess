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
    @board = Matrix.build(8,8).each_with_index {|row_col| initialize_field(row_col)} 
    setup_board()
  end

  def initialize_field(row_col)
    row = row_col.first
    col = row_col.last
    numbers_hash = get_number_to_letter_hash()
    letter = numbers_hash["#{col}"]
    id = "#{letter}#{8-row}"
    position = [row,col]
    Field.new(id, position)
  end

  def print_board
    puts "  ---------------------------------"
    self.board.row_vectors.each_with_index do |row, row_index|
      print "#{8-row_index} "
      row.to_a.each do |field|
        print "| #{field.to_s} "
      end
      puts "|"
      puts "  ---------------------------------"
    end
    puts "    a   b   c   d   e   f   g   h  "
  end

  def valid_move?(start_field, end_field, current_player)
    # it is a valid move if
      # - the start_field is occupied by own piece
      # - the destination is reachable
      # - no other piece is in the way (except for the knight)
      # - if its a taking the field must be occupied by an opponents piece
    puts "valid_move?"
      if valid_start_field?(start_field, current_player)
      moving_piece = start_field.piece
      if (moving_piece.chosen_destination_reachable?(end_field) && clear_way?(moving_piece.get_field_positions_on_way(end_field)))
        if valid_end_field?(end_field, current_player)
          return true
        end
      end
    end
    false
  end

  def valid_start_field?(start_field, current_player)
    if start_field.occupies_cp_piece?(current_player)
      return true
    end
    puts "Pick one of YOUR figures: "
    return false
  end

  def clear_way?(positions_inbetween)
    fields_inbetween = self.board.select {|field| positions_inbetween.include?(field.position)}
    return fields_inbetween.all?{|field| !field.occupies_piece?}
  end

  def valid_end_field?(end_field, current_player)
    # either field is unoccupied or its occupied by the opponent
    (end_field.occupies_opponent_piece?(current_player) || !end_field.occupies_piece?)
  end

  def move_piece(start_field, end_field, current_player)
    if start_field.occupies_piece?
      unless start_field.occupies_cp_piece?(current_player)
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

  def get_field(destination_pattern)
    self.board.select{|field| field.id == destination_pattern}.first
  end

  def get_number_to_letter_hash
    # converts the number 0..7 to the letters a..h
    letters = ('a'..'h').to_a
    numbers = (0..7).to_a.map(&:to_s)
    numbers_hash = numbers.zip(letters).to_h
    numbers_hash
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

  def checkmate?
    
  end

  def check?

  end

  def king_captured?

  end
end