require_relative "../lib/player"
require_relative "../lib/chessBoard"

class ChessGame
attr_accessor :chess_board, :player1, :player2, :current_player

  def initialize
    @chess_board = ChessBoard.new
    @player1 = Player.new(get_player_name("Player1"), :white)
    @player2 = Player.new(get_player_name("Player2"), :black)
    @current_player = self.player1
  end

  def get_player_name(player)
    print "\n#{player} type your name: "
    gets.chomp
  end

  def start
    until victory?()
      print_beginning_of_turn()
      make_move()
      switch_player()
    end
  end

  def victory?
    if self.chess_board.victory?
      end_game()
    else
      false
    end
  end

  def print_beginning_of_turn
    puts "_______________________________________"
    self.chess_board.print_captured_pieces(:white)
    self.chess_board.print_board
    self.chess_board.print_captured_pieces(:black)
    puts "#{self.current_player.name}, it's your turn:"
  end

  def make_move
    fields = get_start_end_field()   
    until self.chess_board.valid_move?(fields.first, fields.last, self.current_player)
      fields = get_start_end_field()
    end
    self.chess_board.move_piece(fields.first, fields.last, self.current_player) 
  end

  def get_start_end_field()
    players_move = get_valid_move_pattern()
    start_field = self.chess_board.get_field(players_move[0..1])
    end_field = self.chess_board.get_field(players_move[2..3])
    [start_field, end_field]
  end

  def get_valid_move_pattern
    players_move = get_player_input()
    input_eql_exit?(players_move)
    until valid_input_pattern?(players_move)
      puts "Choose a valid move: "
      players_move = get_player_input()
      input_eql_exit?(players_move)
    end
    players_move
  end

  def get_player_input
    print "Make your move (for e.g. a2a4): "
    gets.chomp.downcase
  end

  def valid_input_pattern?(pattern)
    pattern.match?(/^[a-h][1-8][a-h][1-8]$/)
  end

  def switch_player
    if self.current_player == self.player1
      self.current_player = self.player2
    else
      self.current_player = self.player1
    end
  end

  def input_eql_exit?(input)
    if input == "exit"
      end_game()
    end
  end

  def end_game
    exit
  end

end