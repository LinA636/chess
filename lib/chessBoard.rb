require_relative "../lib/field"
require_relative "../lib/pawn"
require_relative "../lib/rook"
require_relative "../lib/knight"
require_relative "../lib/bishop"
require_relative "../lib/queen"
require_relative "../lib/king"
require "matrix"

class ChessBoard
  attr_accessor :board, :captured_white_pieces, :captured_black_pieces, :white_pieces, :black_pieces
  def initialize
    @board = Matrix.build(8,8).each_with_index {|row_col| initialize_field(row_col)} 
    @captured_white_pieces = []
    @captured_black_pieces = []
    @white_pieces = []
    @black_pieces = []
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

  def setup_board
    self.board.row(0).each_with_index do |field, column| 
      case column
      when 0, 7
        field.piece = Rook.new(:black, field.position)
      when 1, 6
        field.piece = Knight.new(:black, field.position)
      when 2, 5
        field.piece = Bishop.new(:black, field.position)
      when 3
        field.piece = Queen.new(:black, field.position)
      when 4
        field.piece = King.new(:black, field.position)
      end

      self.black_pieces << field.piece
    end

    self.board.row(1).each_with_index do |field, column| 
      field.piece = Pawn.new(:black,field.position)
      self.black_pieces << field.piece
    end

    self.board.row(6).each_with_index do |field, column| 
      field.piece = Pawn.new(:white, field.position)
      self.white_pieces << field.piece
    end

    self.board.row(7).each_with_index do |field, column| 
      case column
      when 0, 7
        field.piece = Rook.new(:white, field.position)
      when 1, 6
        field.piece = Knight.new(:white, field.position)
      when 2, 5
        field.piece = Bishop.new(:white, field.position)
      when 3
        field.piece = Queen.new(:white, field.position)
      when 4
        field.piece = King.new(:white, field.position)
      end
      self.white_pieces << field.piece
    end
  end

  #-- printing methods --
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

  def print_captured_pieces(color)
    puts
    if color == :white
      captured_white_pieces.each{|piece| print "#{piece}  "}
    elsif color == :black
      captured_black_pieces.each{|piece| print "#{piece}  "}
    end
    puts
  end


  #-- controll methods if move is valid --
  def valid_move?(start_field, end_field, current_player)
    # it is a valid move if
      # - the start_field is occupied by own piece
      # - the destination is reachable
      # - no other piece is in the way (except for the knight - she jumps)
      # - if its a taking the field must be occupied by an opponents piece
    if valid_start_field?(start_field, current_player)
      moving_piece = start_field.piece
      if moving_piece.chosen_destination_reachable?(end_field) 
        fields_inbetween = moving_piece.get_field_positions_on_way(end_field)
        if (clear_way?(fields_inbetween) && valid_end_field?(moving_piece, end_field, current_player))
          return true
        end
      end
    end
    false
  end

  def valid_start_field?(start_field, current_player)
    if start_field.empty?
      puts "Choose a start field containing your piece: "
      false
    elsif start_field.occupies_cp_piece?(current_player)
      true      
    else
      puts "Pick one of YOUR figures: "
      false
    end
  end

  def clear_way?(positions_inbetween)
    fields_inbetween = self.board.select {|field| positions_inbetween.include?(field.position)}
    if fields_inbetween.all?{|field| !field.occupies_piece?}
      return true
    end
    puts "Choose a destination with a clear way: "
    false
  end

  def valid_end_field?(moving_piece, end_field, current_player)
    # either field is unoccupied or its occupied by the opponent
    # if moving_piece is a pawn check if it is making a move or a taking
    if moving_piece.instance_of?(Pawn) && moving_piece.taking?(end_field)
      if end_field.occupies_opponent_piece?(get_opposite_color(current_player.color))
        return true
      else
        puts "Choose a valid destination: "
        return false
      end
    elsif (end_field.occupies_opponent_piece?(get_opposite_color(current_player.color)) || !end_field.occupies_piece?)
      return true
    else
      puts "Choose a valid destination: "
      false
    end
  end


  #-- move the piece --
  def move_piece(start_field, end_field, current_player)
    # start_field is already tested to occupie current_players piece
    # end_field is reachable without other pieces being in the way or being occupied by own piece
    moving_piece = start_field.piece
    update_end_field(end_field, moving_piece)
    update_start_field(start_field)
  end

  def update_end_field(end_field, moving_piece)
    # if end_field is empty assign moving_piece to it
    # else mark captured piece as captured and safe it to apporiate array, then assign moving_piece to end_field
    if end_field.empty?
      moving_piece.position = end_field.position
      end_field.piece = moving_piece
    else
      end_field.piece.captured = true
      if end_field.piece.color == :white 
        self.captured_white_pieces << end_field.piece
        self.white_pieces.delete(end_field.piece)
        p white_pieces.length
      else 
        self.captured_black_pieces << end_field.piece
        self.black_pieces.delete(end_field.piece)
        p black_pieces.length
      end
      moving_piece.position = end_field.position
      end_field.piece = moving_piece
    end
  end

  def update_start_field(start_field)
    start_field.piece = nil
  end


  #-- help methods --
  def get_field(field_id)
    self.board.select{|field| field.id == field_id}.first
  end

  def get_field_with_position(field_position)
    self.board.select{|field| field.position == field_position}.first
  end

  def get_number_to_letter_hash
    # converts the number 0..7 to the letters a..h
    letters = ('a'..'h').to_a
    numbers = (0..7).to_a.map(&:to_s)
    numbers_hash = numbers.zip(letters).to_h
    numbers_hash
  end

  def find_kings()
    white_king = (self.white_pieces + self.captured_white_pieces).select{|piece|piece.instance_of?(King)}.first
    black_king = (self.black_pieces + self.captured_black_pieces).select{|piece|piece.instance_of?(King)}.first
    [white_king, black_king]
  end

  def get_opposite_color(color)
    if color == :white
      return :black
    else
      return :white
    end
  end

  def pieces_able_to_reach_field(destination_field, attack_color, take_move = ' ')
    # selects all the pieces in given color, which can reach the destination field, without other pieces being in their way
    if attack_color == :white
      return self.white_pieces.select do |piece|
          unless piece.instance_of?(King)
            piece.chosen_destination_reachable?(destination_field, take_move) && clear_way?(piece.get_field_positions_on_way(destination_field))
          end
        end
    else
      return self.black_pieces.select do |piece|
          unless piece.instance_of?(King)
            piece.chosen_destination_reachable?(destination_field, take_move) && clear_way?(piece.get_field_positions_on_way(destination_field))
          end
        end
    end
  end
  

  #-- check for victory --
  def victory?
    # returns winner color or false, if there is no victory
    kings = find_kings()
    white_king = kings.first
    black_king = kings.last

    if king_captured?(white_king)
      return :black
    elsif king_captured?(black_king)
      return :white
    end

    if check?(white_king)
      if checkmate?(white_king)
        announce_checkmate(white_king.color)
        return :black
      else
        announce_check(white_king.color)
        return false
      end
    elsif check?(black_king)
      if checkmate?(black_king)
        announce_checkmate(black_king.color)
        return :white
      else
        announce_check(black_king.color)
        return false
      end
    end

    return false
  end

  def checkmate?(king)
    # king is under attack 
    # and the king cant move to a not endangered field 
    # or be saved by another piece
    p king
    king_field = get_field_with_position(king.position)
    pieces_attacking_king = pieces_able_to_reach_field(king_field, get_opposite_color(king.color))
    unless pieces_attacking_king.empty?  
      # check if there is no escape and no possible sacrifice
      return (!king_can_escape?(king) && !sacrifice_possible?(king, pieces_attacking_king)) ? true : false
    else
      # king is not under attack
      return false
    end
  end

  def king_can_escape?(king)
    #check if there is a field the king can go to
    escape_fields = get_fields_king_can_escape_to(king)
    if escape_fields.empty?
      return false
    else
      # check if that field is endangered by the opponent
      p "\nking can escape to:"
      p fields_not_endangered_by_opponent(escape_fields, king)
      return fields_not_endangered_by_opponent(escape_fields, king).empty? ? false : true
    end
  end

  def get_fields_king_can_escape_to(king)
    neighbour_fields_positions = king.next_movements
    #neighbour_fields = self.board.select{|field| neighbour_fields_positions.include?(field.position)}
    neighbour_fields = neighbour_fields_positions.map{|position| get_field_with_position(position)}
    
    neighbour_fields.select{|field| (field.empty? || field.occupies_opponent_piece?(get_opposite_color(king.color)))}.select{|field| pieces_able_to_reach_field(field, get_opposite_color(king.color)).empty?}
  end

  def fields_not_endangered_by_opponent(escape_fields, king)
    #returns those fields, which are not endangered by an opponent piece
    escape_fields.select{|field| pieces_able_to_reach_field(field, get_opposite_color(king.color), 'take').empty?}
  end

  def sacrifice_possible?(king, pieces_attacking_king)
    # check if there is another piece of the kings color to be moved between king and its opponent
    king_field = get_field_with_position(king.position)
    #get fields inbetween the pieces attacking the king and the king
    field_positions_inbetween = pieces_attacking_king.map{|piece| piece.get_field_positions_on_way(king_field)}.flatten(1)
    fields_inbetween = field_positions_inbetween.map{|position| get_field_with_position(position)}
    fields_inbetween.any? do |field| 
      take_move = (field.piece == nil ? "move" : "take")
      !pieces_able_to_reach_field(field, king.color, take_move).empty?
    end
  end

  def check?(king)
    # state of a king, if he can be captured within one move of the opponent, but the king still can be safed by current player
      # check if king is reachable, by any of opponents pieces
      # check if the king can move to another field (empty field or field occupied by opponent?)
      # check if there is another piece which can be sacrifieced
    king_field = get_field_with_position(king.position)
    pieces_attacking_king = pieces_able_to_reach_field(king_field, get_opposite_color(king.color))
    if pieces_attacking_king.empty?
      # king is not under attack
      return false
    elsif pieces_attacking_king.length == 1
      # check if king can escape or if another piece can be sacrificed
      return (attacker_can_be_taken?(pieces_attacking_king, king) || king_can_escape?(king) || sacrifice_possible?(king, pieces_attacking_king)) ? true : false
    else
      # more than one piece attacking
      return true
    end
  end

  def king_captured?(king)
    king.captured  
  end

  def attacker_can_be_taken?(pieces_attacking_king, king)
    # check if attacker_pieces can be taken
    if pieces_attacking_king.length > 1
      return false
    else
      fields_pieces_attacking_king = pieces_attacking_king.map{|piece| get_field_with_position(piece.position)}
      fields_pieces_attacking_king.any?{|field| !pieces_able_to_reach_field(field, king.color, 'take').empty?} 
    end
  end


  #-- announcements --
  def announce_checkmate(color)
    puts "#{color} checkmate!"
  end

  def announce_check(color)
    puts "#{color} check!"
  end

end