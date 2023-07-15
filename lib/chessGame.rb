class ChessGame
attr_accessor :board, :player1, :player2, :current_player

  def initialize
    @board = ChessBoard.new
    @player1 = Player.new("Player 1", :white)
    @player2 = Player.new("Player 2", :black)
    @current_player = @player1
  end


=begin  
  #start_game
    # Therefore print the Explanations: How to
      - save the game
      - exit the game
      - start a new game
      - resume an old game

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