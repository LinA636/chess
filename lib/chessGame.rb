require_relative "../lib/player"
require_relative "../lib/chessBoard"

class ChessGame
attr_accessor :board, :player1, :player2, :current_player

  def initialize
    @board = ChessBoard.new
    @player1 = Player.new(get_player_name("Player1"), :white)
    @player2 = Player.new(get_player_name("Player2"), :black)
    @current_player = self.player1
  end

  def get_player_name(player)
    puts "#{player} type your name: "
    gets.chomp
  end

  def start
    until victory?
      print_beginning_of_turn
      make_move
    end
  end

  def victory?
    # king in checkmate
    # king captured
  end

  def print_beginning_of_turn
    puts "_______________________________________"
    self.board.print_board
    puts "#{self.current_player.name}, it's your turn:"
  end

  def make_move
    move_pattern = get_move_pattern
    validate_move_pattern(move_pattern)
  end

  def get_move_pattern
    players_move = get_player_input
    until valid_input_pattern?(players_move)
      players_move = get_player_input
    end
    players_move
  end

  def get_player_input
    puts "Make your move (for e.g. a2a4): "
    gets.chomp.downcase
  end

  def valid_input_pattern?(move)
    move.match?(/^[a-h][1-8][a-h][1-8]$/)
  end

  def validate_move_pattern(move_pattern)
    start_destination = move_pattern[0..1]
    end_destination = move_pattern[2..3]
    occupies_cp_piece?(start_destination)
  end

  def occupies_cp_piece? #cp: current_player
    
  end

  def valid_move?
    # start_field actually occupies current_players piece?
    # destination field does not occupy current_players piece?
    # destination_field valid move for chosen piece?
    # no other piece in the way of chosen piece? (except for knight)
  end
=begin  
  #start_game
    # Therefore print the Explanations: How to
      - save the game -> always possible
      - exit the game -> always possible
      - start a new game -> only at beginning
      - resume an old game -> only at beginning

    # Make player decide to start a new game or (if available) resume an old game

    (each turn will be framed by a straight line in  the command line!)
    
    first turn:
      # print straight line
      # print board
      # print name of current_player
      # make move
          # make current_player put in the move (feg a1a2)
          - make two variables: start_pos and destination
          # check if choosen field contains players piece
              if not: # make move
          # check if destination is valid
                - valid move for chosen piece? (is one of the children?)
                - for pawn: is movement or taking?
                - destination does not occupy one of the current_players pieces.
          # check if a piece of opponent is going to be captured.
                if yes: # mark captured piece as captured
                        if piece is king: # announce winner
          # occupy that field with new piece
          # reset old field to default state
          # check board for any kings in 'check'
              if yes: # announce check
          # check board for any kings in 'check mate'
                if yes: # announce check-mate
                        # announce winner
          # switch player
      # check for victory - king captured
                          - king in check-mate
                if victory: #end game
                if not:
    second turn:
      same procedure
                
=end


end