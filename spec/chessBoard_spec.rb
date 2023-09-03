require_relative "../lib/chessBoard"

describe ChessBoard do
  subject(:chess_board){described_class.new}
  before do
    # Redirect stdout to a StringIO object
    #@original_stdout = $stdout
    #$stdout = StringIO.new
    allow($stdout).to receive(:puts)
  end

  after do
    # Restore stdout to its original value after each example
    #$stdout = @original_stdout
  end

  describe '#initialize' do
    it 'creates an 8x8 board with initialized fields' do
      expect(chess_board.board.row_count).to eq(8)
      expect(chess_board.board.column_count).to eq(8)
      expect(chess_board.board.all? { |field| field.is_a?(Field) }).to be true
    end
  end

  describe '#valid_start_field?' do
    let(:current_player){double('Player', color: :white)}
    let(:opponent_player){double('Player', color: :black)}
  
    context 'when start_field is occupied by the current_player' do
      let(:start_field){double('Field', id: "a1", position: [7,0])}
      before do
        allow(start_field).to receive(:empty?).and_return(false)
        allow(start_field).to receive(:occupies_cp_piece?).and_return(true)
      end
      it 'returns true' do
        expect(chess_board.valid_start_field?(start_field, current_player)).to be true
      end
    end

    context 'when start_field is not occupied by the current player' do
      let(:start_field){double('Field', id: "a8", position: [0,0])}
      before do
        allow(start_field).to receive(:empty?).and_return(false)
        allow(start_field).to receive(:occupies_cp_piece?).and_return(false)
      end
      it 'returns false' do
        expect(chess_board.valid_start_field?(start_field, current_player)).to be false
      end
    end

    context 'when start_field is empty' do
      let(:start_field){double('Field', id: "c4", position: [4,2])}
      before do
        allow(start_field).to receive(:empty?).and_return(true)
      end
      it 'returns false' do
        expect(chess_board.valid_start_field?(start_field, current_player)).to be false
      end
    end
  end

  describe '#clear_way?' do
    let(:position_inbetween){[[6,0],[5,0], [4,0],[3,0]]}

    context 'when positions_inbetween are not occupied' do
      it 'returns true' do
        chess_board.board[6,0].piece = nil
        expect(chess_board.clear_way?(position_inbetween)).to be true
      end
    end

    context 'when one field inbetween is occupied' do
      it 'retruns false' do
        expect(chess_board.clear_way?(position_inbetween)).to be false
      end
    end

    context 'when two fields inbetween are occupied' do
      it 'returns false' do
        chess_board.board[3,0].piece = Pawn.new(:black, [3,0])
        solution = chess_board.clear_way?(position_inbetween)
        expect(solution).to be false
      end
    end
  end
  
  describe '#valid_end_field?' do
    let(:current_player){double('Player', color: :white)}
    context 'when moving_piece is not a pawn or it is a pawn doing a normal move' do
      let(:moving_piece){double('Rook', color: :white)}
      context 'when destination field is occupied by current player' do
        let(:end_field){chess_board.board[7,0]}
        it 'returns false' do
          expect(chess_board.valid_end_field?(moving_piece, end_field, current_player)).to be false
        end
      end

      context 'when destination is not occupied' do
        let(:end_field){chess_board.board[3,3]}
        it 'returns true' do
          expect(chess_board.valid_end_field?(moving_piece, end_field, current_player)).to be true
        end
      end

      context 'when destination is occupied by an opponent' do
        let(:end_field){chess_board.board[1,0]}
        it 'returns true' do
          expect(chess_board.valid_end_field?(moving_piece, end_field, current_player)).to be true
        end
      end
    end

    context 'when moving_piece is a pawn doing a taking' do
      let(:moving_piece){double('Pawn', color: :white, position: [6,0])}
      context 'when destination field is not occupied by opponent player' do
        let(:end_field){chess_board.board[5,1]}
        before do
          allow(moving_piece).to receive(:instance_of?).and_return(true)
          allow(moving_piece).to receive(:taking?).and_return true
          allow(end_field).to receive(:occupies_opponent_piece?).and_return false  
        end

        it 'returns false' do
          expect(chess_board.valid_end_field?(moving_piece, end_field, current_player)).to be false
        end
      end

      context 'when destination is occupied by opponent player' do
        it 'returns true' do
          chess_board.board[5,1].piece = double('Pawn', color: :black, position: [5,1])
          end_field = chess_board.board[5,1]
          expect(chess_board.valid_end_field?(moving_piece, end_field, current_player)).to be true
        end
      end
    end

  end

  describe '#valid_move?' do
    let(:current_player){double('Player', color: :white)}
    context 'when start_field contains current players piece' do
      let(:start_field){chess_board.board[7,0]}
      let(:moving_piece){start_field.piece}
      context 'when destination is reachable and no piece is in the way' do
        before do
          allow(moving_piece).to receive(:chosen_destination_reachable?).and_return(true)
          allow(chess_board).to receive(:clear_way?).and_return(true)
        end
        context 'when end_field is empty' do
          it 'returns true' do
            end_field = chess_board.board[3,0]
            chess_board.board[6,0].piece = nil
            expect(chess_board.valid_move?(start_field, end_field, current_player)).to be true
          end
        end

        context 'when end_field is occupied by an opponent' do
          it 'returns true' do
            end_field = chess_board.board[1,0]
            chess_board.board[6,0].piece = nil
            expect(chess_board.valid_move?(start_field, end_field, current_player)).to be true
          end
        end

        context 'when end_field is occupied by current player' do
          it 'returns false' do
            end_field = chess_board.board[6,0]
            expect(chess_board.valid_move?(start_field, end_field, current_player)).to be false
          end
        end
      end

      context 'when destination is reachable but a piece is in the way' do
        before do
          allow(moving_piece).to receive(:chosen_destination_reachable?).and_return(true)
          allow(chess_board).to receive(:clear_way?).and_return(false)
        end
        it 'returns false' do
          end_field = chess_board.board[5,0]
          expect(chess_board.valid_move?(start_field, end_field, current_player)).to be false
        end
      end

      context 'when destination is not reachable' do
        before do
          allow(moving_piece).to receive(:chosen_destination_reachable?).and_return(false)
        end
        it 'returns false' do
          end_field = chess_board.board[5,0]
          expect(chess_board.valid_move?(start_field, end_field, current_player)).to be false
        end
      end
    end
  
    context 'when start_field is invalid' do
      let(:end_field){chess_board.board[3,2]}
      context 'when start_field is empty' do
        let(:start_field){chess_board.board[3,2]}
        it 'returns false' do
          allow(chess_board).to receive(:valid_start_field).and_return(false)
          expect(chess_board.valid_move?(start_field, end_field, current_player)).to be false
        end
      end

      context 'when start_field occupies opponent piece' do
        before do
          end
        it 'returns false' do
          start_field = chess_board.board[1,1]
          allow(chess_board).to receive(:valid_start_field).and_return(false)
          expect(chess_board.valid_move?(start_field, end_field, current_player)).to be false
        end
      end
    end
  end

  describe '#pieces_able_to_reach_field' do

    context 'when there is one piece able to reach the field' do
      let(:destination_field){chess_board.board[6,5]}
      let(:attack_color){:black}
      before do
        chess_board.board[5,4].piece = Pawn.new(:black, [5,4])
        chess_board.black_pieces << chess_board.board[5,4].piece
      end

      it 'returns that piece in an array' do
        solution = chess_board.pieces_able_to_reach_field(destination_field, attack_color)
        expect(solution).to match([chess_board.board[5,4].piece])
      end
    end

    context 'when there are two pieces able to reach the field' do
      let(:destination_field){chess_board.board[6,5]}
      let(:attack_color){:black}
      before do
        chess_board.board[5,4].piece = Pawn.new(:black, [5,4])
        chess_board.black_pieces << chess_board.board[5,4].piece

        chess_board.board[2,5].piece = Rook.new(:black, [2,5])
        chess_board.black_pieces << chess_board.board[2,5].piece
      end

      it 'returns both pieces in an array' do
        solution = chess_board.pieces_able_to_reach_field(destination_field, attack_color)
        expect(solution).to match([chess_board.board[5,4].piece, chess_board.board[2,5].piece])
      end
    end

    context 'when there are no pieces able to reach the field' do
      let(:destination_field){chess_board.board[6,4]}
      let(:attack_color){:black}
      
      it 'returns empty array' do
        solution = chess_board.pieces_able_to_reach_field(destination_field, attack_color)
        expect(solution).to match([])
      end
    end
  end

  describe '#get_fields_king_can_escape_to' do
    let(:king){chess_board.board[7,4].piece}
    context 'when king is surrounded by its own pieces' do
      it 'returns empty array' do
        solution = chess_board.get_fields_king_can_escape_to(king)
        expect(solution).to match([])  
      end
    end

    context 'when there is one unoccupied field' do
      before do
        chess_board.board[6,5].piece = nil
      end
      it 'returns that empty field' do
        solution = chess_board.get_fields_king_can_escape_to(king)
        expect(solution).to match([chess_board.board[6,5]]) 
      end
    end

    context 'when there is one field occupied by the opponent' do
      before do
        chess_board.board[6,5].piece = double('Pawn', color: :black, position: [6,5])
      end
      it 'returns that field' do
        solution = chess_board.get_fields_king_can_escape_to(king)
        expect(solution).to match([chess_board.board[6,5]]) 
      end
    end

    context 'when there is one unoccupied field and one field occupied by the opponent' do
      before do
        chess_board.board[6,5].piece = double('Pawn', color: :black, position: [6,5])
        chess_board.board[6,4].piece = nil
      end
      it 'returns an array of those fields' do
        solution = chess_board.get_fields_king_can_escape_to(king)
        expect(solution).to match([chess_board.board[6,4], chess_board.board[6,5]]) 
      end
    end
  end

  describe '#fields_not_endangered_by_opponent' do
    let(:king){chess_board.board[7,4].piece}
    let(:escape_fields){[chess_board.board[6,5], chess_board.board[6,4]]}

    context 'when there are two fields the king can escape to and none is endangered by an opponent' do
      before do
        # prepare board
        # put opponent on [6,5] to attack king
        chess_board.white_pieces.delete(chess_board.board[6,5].piece)
        chess_board.board[6,5].piece = Pawn.new(:black, [6,5])
        chess_board.black_pieces << chess_board.board[6,5].piece
        # empty field above king
        chess_board.white_pieces.delete(chess_board.board[6,4].piece)
        chess_board.board[6,4].piece = nil
      end

      it 'returns all those fields in an array' do
        solution = chess_board.fields_not_endangered_by_opponent(escape_fields, king)
        expect(solution).to match(escape_fields)
      end
    end

    context 'when there are two escape fields and one field is not endangered by an opponent' do
      before do
        # prepare board
        # put opponent on [6,5] to attack king
        chess_board.white_pieces.delete(chess_board.board[6,5].piece)
        chess_board.board[6,5].piece = Pawn.new(:black, [6,5])
        chess_board.black_pieces << chess_board.board[6,5].piece
        # empty field above king
        chess_board.white_pieces.delete(chess_board.board[6,4].piece)
        chess_board.board[6,4].piece = nil
        # endangers [6,5]
        chess_board.board[5,4].piece = Pawn.new(:black, [5,4])
        chess_board.black_pieces << chess_board.board[5,4].piece
      end
      
      it 'returns array with that field' do
        solution = chess_board.fields_not_endangered_by_opponent(escape_fields, king)
        expect(solution).to match([chess_board.board[6,4]])
      end
    end

    context 'when there are two escape fields and both are endangered by an opponent' do
      before do
        # prepare board
        # put opponent on [6,5] to attack king
        chess_board.white_pieces.delete(chess_board.board[6,5].piece)
        chess_board.board[6,5].piece = Pawn.new(:black, [6,5])
        chess_board.black_pieces << chess_board.board[6,5].piece
        # empty field above king
        chess_board.white_pieces.delete(chess_board.board[6,4].piece)
        chess_board.board[6,4].piece = nil
        # endangers [6,5]
        chess_board.board[5,4].piece = Pawn.new(:black, [5,4])
        chess_board.black_pieces << chess_board.board[5,4].piece
        #endangers [6,4]
        chess_board.board[4,2].piece = Bishop.new(:black, [4,2])
        chess_board.black_pieces << chess_board.board[4,2].piece
      end
      
      it 'returns an empty array' do
        solution = chess_board.fields_not_endangered_by_opponent(escape_fields, king)
        expect(solution).to match([])
      end
    end

    context 'when there is one field the king itself protects' do
      before do
        # empty field [6,4]
        chess_board.captured_white_pieces << chess_board.board[6,4].piece
        chess_board.white_pieces.delete(chess_board.board[6,4].piece)
        # move king to field [6,4]
        chess_board.board[7,4].piece.position = [6,4]
        chess_board.board[6,4].piece = chess_board.board[7,4].piece
        chess_board.board[7,4].piece = nil

        # position pieces on  [5,3] and [5,5] to prevent king moving there
        chess_board.board[5,3].piece = Pawn.new(:white, [5,3])
        chess_board.white_pieces << chess_board.board[5,3].piece
        chess_board.board[5,5].piece = Pawn.new(:white, [5,5])
        chess_board.white_pieces << chess_board.board[5,5].piece

        # postion opponent-rook to attack king
        chess_board.board[2,4].piece = Rook.new(:black, [2,4])
        chess_board.black_pieces << chess_board.board[2,4].piece
      end

      let(:escape_fields) {[chess_board.board[5,4], chess_board.board[7,4]]}
      let(:king){chess_board.board[6,4].piece}
      it 'returns empty field' do
        solution = chess_board.fields_not_endangered_by_opponent(escape_fields, king)
        expect(solution).to match([])
      end
    end
  end

  describe '#update_end_field' do
    let(:moving_piece){chess_board.board[6,5].piece}

    context 'when end_field is empty' do
      let(:end_field){chess_board.board[5,5]}

      it 'assigns moving_piece to that field' do
        chess_board.update_end_field(end_field, moving_piece)
        expect(chess_board.board[5,5].piece).to match(moving_piece)
      end
    end

    context 'when end_field is occupied' do
      let(:end_field){chess_board.board[5,6]}

      context 'when piece is black' do
        before do
          chess_board.board[5,6].piece = Rook.new(:black, [5,6])
          chess_board.black_pieces << chess_board.board[5,6].piece
        end

        it 'marks that piece as captured, saves it to captured_black_pieces, deletes it from black_pieces and assigns moving_piece to that field' do
          captured_piece = chess_board.board[5,6].piece
          chess_board.update_end_field(end_field, moving_piece)
          expect(captured_piece.captured).to be true
          expect(chess_board.captured_black_pieces).to include(captured_piece)
          expect(chess_board.black_pieces).not_to include(captured_piece)
          expect(chess_board.board[5,6].piece).to match(moving_piece)
        end
      end

      context 'when piece is white' do
        it 'marks that piece as captured, saves it to captured_white_pieces, deletes it from white_pieces and assigns moving_piece to that field' do
          chess_board.update_end_field(end_field, moving_piece)
        end

        before do
          chess_board.board[5,6].piece = Rook.new(:white, [5,6])
          chess_board.white_pieces << chess_board.board[5,6].piece
        end

        it 'marks that piece as captured, saves it to captured_black_pieces, deletes it from black_pieces and assigns moving_piece to that field' do
          captured_piece = chess_board.board[5,6].piece
          chess_board.update_end_field(end_field, moving_piece)
          expect(captured_piece.captured).to be true
          expect(chess_board.captured_white_pieces).to include(captured_piece)
          expect(chess_board.white_pieces).not_to include(captured_piece)
          expect(chess_board.board[5,6].piece).to match(moving_piece)
        end
      end
    end
  end

  describe 'king_can_escape?' do
    let(:king){chess_board.board[7,4].piece} # white king
    context 'when there is no field the king can go to' do
      it 'returns false'do
        solution = chess_board.king_can_escape?(king)
        expect(solution).to be false
      end
    end

    context 'when there is one field the king can go to' do
      before do
        chess_board.captured_white_pieces << chess_board.board[6,4].piece
        chess_board.white_pieces.delete(chess_board.board[6,4].piece)
        chess_board.board[6,4].piece = nil
      end

      context 'when that field is endangered by an opponent' do
        before do
          chess_board.board[2,4].piece = Rook.new(:black, [2,4])
          chess_board.black_pieces << chess_board.board[2,4].piece
        end

        it 'returns false' do
          solution = chess_board.king_can_escape?(king)
          expect(solution).to be false
        end
      end

      context 'when that field is not endangered by an opponent' do
        it 'returns true' do
          solution = chess_board.king_can_escape?(king)
          expect(solution).to be true
        end
      end
    end
  end

  describe '#sacrifice_possible?' do
    before do
      #preparing the board -> no pieces aroung the king
      chess_board.captured_white_pieces << chess_board.board[6,3].piece
      chess_board.white_pieces.delete(chess_board.board[6,3].piece)
      chess_board.board[6,3].piece = nil

      chess_board.captured_white_pieces << chess_board.board[6,4].piece
      chess_board.white_pieces.delete(chess_board.board[6,4].piece)
      chess_board.board[6,4].piece = nil

      chess_board.captured_white_pieces << chess_board.board[6,5].piece
      chess_board.white_pieces.delete(chess_board.board[6,5].piece)
      chess_board.board[6,5].piece = nil

      chess_board.captured_white_pieces << chess_board.board[7,3].piece
      chess_board.white_pieces.delete(chess_board.board[7,3].piece)
      chess_board.board[7,3].piece = nil

      chess_board.captured_white_pieces << chess_board.board[7,5].piece
      chess_board.white_pieces.delete(chess_board.board[7,5].piece)
      chess_board.board[7,5].piece = nil

      # an opponent rook attacking the king
      chess_board.board[2,4].piece = Rook.new(:black, [2,4])
      chess_board.black_pieces << Rook.new(:black, [2,4])
    end

    let(:king){chess_board.board[7,4].piece}
    let(:pieces_attacking_king){[chess_board.board[2,4].piece]}

    context 'when there is no other piece to be sacrificed' do
      before do
        # no knight to save the king
        chess_board.captured_white_pieces << chess_board.board[7,6].piece
        chess_board.white_pieces.delete(chess_board.board[7,6].piece)
        chess_board.board[7,5].piece = nil
        # no bishop to save the king
        chess_board.captured_white_pieces << chess_board.board[7,2].piece
        chess_board.white_pieces.delete(chess_board.board[7,2].piece)
        chess_board.board[7,2].piece = nil
      end

      it 'returns false' do
        solution = chess_board.sacrifice_possible?(king, pieces_attacking_king)
        expect(solution).to be false
      end
    end

    context 'when there is one piece to be sacrificed' do
      before do
        # no knight to save the king
        chess_board.captured_white_pieces << chess_board.board[7,6].piece
        chess_board.white_pieces.delete(chess_board.board[7,6].piece)
        chess_board.board[7,5].piece = nil
      end

      it 'returns true' do
        # there is a bishop on field [7,2], which can move to field [5,4] to save the king
        solution = chess_board.sacrifice_possible?(king, pieces_attacking_king)
        expect(solution).to be true
      end
    end

    context 'when there are two pieces to be sacrificed' do
      it 'returns true' do
        # there is a bishop on field [7,2], which can move to field [5,4] to save the king
        # and a knight on [7,6], which can be moved to [6,4]
        solution = chess_board.sacrifice_possible?(king, pieces_attacking_king)
        expect(solution).to be true
      end
    end
  end

  describe '#attacker_can_be_taken' do
    let(:king){chess_board.board[7,4].piece}
    before do
      # prepare board
      chess_board.board[2,4].piece = Rook.new(:black, [2,4])
      chess_board.black_pieces << chess_board.board[2,4].piece

      chess_board.board[5,3].piece = Knight.new(:black, [5,3])
      chess_board.black_pieces << chess_board.board[5,3].piece
    end

    context 'when there are more than one attacker' do
      let(:pieces_attacking_king){[chess_board.board[2,4].piece, chess_board.board[5,3].piece]}
      
      it 'returns false' do
        solution = chess_board.attacker_can_be_taken?(pieces_attacking_king, king)
        expect(solution).to be false
      end
    end

    context 'when there is one attacker' do
      let(:pieces_attacking_king){[chess_board.board[2,4].piece]}
      
      context 'when attacker can be taken' do
        before do
          # position a white pawn to take the attacker
          chess_board.board[3,3].piece = Pawn.new(:white, [3,3])
          chess_board.white_pieces << chess_board.board[3,3].piece
        end
        it 'returns true' do
          solution = chess_board.attacker_can_be_taken?(pieces_attacking_king, king)
          expect(solution).to be true
        end
      end

      context 'when attacker cannot be taken' do
        it 'returns false' do
          solution = chess_board.attacker_can_be_taken?(pieces_attacking_king, king)
          expect(solution).to be false
        end
      end
    end

    
  end

  describe '#check?' do
    let(:king){chess_board.board[7,4].piece} # white king
    
    context 'when king can not be captured within one move of the opponent' do
      it 'returns false' do
        solution = chess_board.check?(king)
        expect(solution).to be false
      end
    end

    context 'when king can be captured within one move of the opponent' do
      before do
        # prepare board
        #remove pawn above king
        chess_board.captured_white_pieces << chess_board.board[6,4].piece
        chess_board.white_pieces.delete(chess_board.board[6,4].piece)
        chess_board.board[6,4].piece = nil

        # set rook attacking king from above
        chess_board.board[2,4].piece = Rook.new(:black, [2,4])
        chess_board.black_pieces << Rook.new(:black, [2,4])
      end

      context 'when there is one attacker' do
        context 'when king can escape' do
          before do
            #remove pawn diagonal of king, so king can escape
            chess_board.captured_white_pieces << chess_board.board[6,5].piece
            chess_board.white_pieces.delete(chess_board.board[6,5].piece)
            chess_board.board[6,5].piece = nil
          end

          it 'returns true' do
            solution = chess_board.check?(king)
            expect(solution).to be true
          end
        end

        context 'when king cannot escape' do
          context 'when another piece can be sacrificed' do
            it 'returns true' do
              # the knight on [7,6] can be sacrificed
              solution = chess_board.check?(king)
              expect(solution).to be true
            end
          end

          context 'when no other piece can be sacrificed' do
            before do
              # move king to field [6,4], as from there it cant be saved by another piece
              chess_board.board[7,4].piece.position = [6,4]
              chess_board.board[6,4].piece = chess_board.board[7,4].piece
              chess_board.board[7,4].piece = nil

              # set rooks to its side and pawns on top of them
              # move pawn from [6,3] to [5,3]
              chess_board.board[6,3].piece.position = [5,3]
              chess_board.board[5,3].piece = chess_board.board[6,3].piece
              # position rook on [6,3]
              chess_board.board[6,3].piece = Rook.new(:white, [6,3])
              chess_board.white_pieces << chess_board.board[6,3].piece
              # position pawn on [5,5]
              chess_board.board[5,5].piece = Pawn.new(:white, [5,5])
              chess_board.white_pieces << chess_board.board[5,5].piece
              # position rook on [6,5]
              chess_board.board[6,5].piece = Rook.new(:white, [6,5])
              chess_board.white_pieces << chess_board.board[6,5].piece

              # occupy [7,4] by another own piece
              chess_board.board[7,4].piece = Rook.new(:white, [7,4])
              chess_board.white_pieces << chess_board.board[7,4].piece
            end

            let(:moved_king){chess_board.board[6,4].piece}
            it 'returns false' do
              solution = chess_board.check?(moved_king)
              expect(solution).to be false
            end
          end
        end

        context 'when attacker can be taken' do
          before do
            # position own piece to take opponent
            chess_board.board[3,3].piece = Pawn.new(:white, [3,3])
            chess_board.white_pieces << chess_board.board[3,3].piece
          end

          it 'returns true' do
            solution = chess_board.check?(king)
            expect(solution).to be true
          end
        end
      end

      context 'when there are two attackers' do
        before do
          # set knight to attack king as well
          chess_board.board[5,3].piece = Knight.new(:black, [5,3])
          chess_board.black_pieces << chess_board.board[5,3].piece
        end

        context 'when king can escape' do
          before do
            #remove bishop next to king, so king can escape
            chess_board.captured_white_pieces << chess_board.board[7,5].piece
            chess_board.white_pieces.delete(chess_board.board[7,5].piece)
            chess_board.board[7,5].piece = nil 
          end

          it 'returns true' do
            solution = chess_board.check?(king)
            expect(solution).to be true
          end
        end

        context 'when king cannot escape' do
          it 'returns false' do
            solution = chess_board.check?(king)
            expect(solution).to be false
          end
        end
      end  
    end    
  end

  describe '#checkmate?' do
    subject(:chess_board){described_class.new}
    let(:king){chess_board.board[7,4].piece}
    
    context 'when king is under attack' do
      before do
        # prepare board
        #remove pawn above king
        chess_board.captured_white_pieces << chess_board.board[6,4].piece
        chess_board.white_pieces.delete(chess_board.board[6,4].piece)
        chess_board.board[6,4].piece = nil
  
        # set rook attacking king from above
        chess_board.board[2,4].piece = Rook.new(:black, [2,4])
        chess_board.black_pieces << Rook.new(:black, [2,4])
      end

      context 'when there is one attacker' do
        context 'when king can escape' do
          before do
            #remove pawn diagonal of king, so king can escape
            chess_board.captured_white_pieces << chess_board.board[6,5].piece
            chess_board.white_pieces.delete(chess_board.board[6,5].piece)
            chess_board.board[6,5].piece = nil
          end

          it 'returns false' do
            solution = chess_board.checkmate?(king)
            expect(solution).to be false
          end
        end

        context 'when another piece can be sacrificed' do
          before do
            # move king to field [6,4], as from there it cant be saved by another piece
            chess_board.board[6,4].piece = chess_board.board[6,5].piece
            chess_board.board[6,5].piece = nil
          end

          it 'returns false' do
            solution = chess_board.checkmate?(king)
            expect(solution).to be false
          end
        end

        context 'when king cant be saved' do
          before do
            # move king to field [6,4], as from there it cant be saved by another piece
            chess_board.board[7,4].piece.position = [6,4]
            chess_board.board[6,4].piece = chess_board.board[7,4].piece
            chess_board.board[7,4].piece = nil

            # position another piece on [5,3] and [5,5]
            chess_board.board[5,3].piece = Pawn.new(:black, [5,3])
            chess_board.black_pieces << chess_board.board[5,3].piece
            chess_board.board[5,5].piece = Pawn.new(:black, [5,5])
            chess_board.black_pieces << chess_board.board[5,5].piece
          end

          let(:dead_king){chess_board.board[6,4].piece}
 
          it 'returns true' do
            solution = chess_board.checkmate?(dead_king)
            expect(solution).to be true
          end
        end
      end     
    end

    context 'when king is not under attack' do
      it 'returns false' do
        solution = chess_board.checkmate?(king)
        expect(solution).to be false
      end
    end
  end
end
