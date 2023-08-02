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
    until victory?
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
    self.chess_board.print_board
    puts "#{self.current_player.name}, it's your turn:"
  end

  def make_move
    fields = get_start_end_field()
    validate_move_pattern(fields.first, fields.last)
    self.chess_board.move_piece(fields.first, fields.last, self.current_player)
  end

  def get_start_end_field()
    players_move = get_valid_move_pattern()
    start_field = self.chess_board.get_field(players_move[0..1])
    end_field = self.chess_board.get_field(players_move[2..3])
    while start_field.empty? || end_field.empty?
      players_move = get_valid_move_pattern()
      start_field = self.chess_board.get_field(players_move[0..1])
      end_field = self.chess_board.get_field(players_move[2..3])
    end
    [start_field, end_field]
  end

  def get_valid_move_pattern
    players_move = get_player_input()
    until valid_input_pattern?(players_move)
      players_move = get_player_input()
    end
    players_move
  end

  def get_player_input
    print "Make your move (for e.g. a2a4): "
    gets.chomp.downcase
  end

  def valid_input_pattern?(move)
    move.match?(/^[a-h][1-8][a-h][1-8]$/)
  end

  def validate_move_pattern(start_field, end_field)
    unless self.chess_board.valid_move?(start_field, end_field, self.current_player)
      make_move()
    end
  end

  def switch_player
    if self.current_player == self.player1
      self.current_player = self.player2
    else
      self.current_player = self.player1
    end
  end

  def end_game
    exit
  end

end