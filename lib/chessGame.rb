class ChessGame
attr_accessor :board, :player1, :player2, :current_player

  def initialize
    @board = ChessBoard.new
    @player1 = Player.new("Player 1", :white)
    @player2 = Player.new("Player 2", :black)
    @current_player = @player1
  end

end