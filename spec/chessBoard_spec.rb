require_relative "../lib/chessBoard"

describe ChessBoard do
  describe '#initialize' do
    subject(:board){described_class.new}
    it 'creates an 8x8 board with initialized fields' do
      expect(board.board.row_count).to eq(8)
      expect(board.board.column_count).to eq(8)
      expect(board.board.all? { |field| field.is_a?(Field) }).to be true
    end
  end

  describe '#valid_start_field?' do
    subject(:board_valid_start_field){described_class.new}
    let(:current_player){double('Player', color: :white)}
    let(:opponent_player){double('Player', color: :black)}
  
    context 'when start_field is occupied by the current_player' do
      let(:start_field){double('Field', id: "a1", position: [7,0])}
      before do
        allow(start_field).to receive(:empty?).and_return(false)
        allow(start_field).to receive(:occupies_cp_piece?).and_return(true)
      end
      it 'returns true' do
        expect(board_valid_start_field.valid_start_field?(start_field, current_player)).to be true
      end
    end

    context 'when start_field is not occupied by the current player' do
      let(:start_field){double('Field', id: "a8", position: [0,0])}
      before do
        allow(start_field).to receive(:empty?).and_return(false)
        allow(start_field).to receive(:occupies_cp_piece?).and_return(false)
      end
      it 'returns false' do
        expect(board_valid_start_field.valid_start_field?(start_field, current_player)).to be false
      end
    end

    context 'when start_field is empty' do
      let(:start_field){double('Field', id: "c4", position: [4,2])}
      before do
        allow(start_field).to receive(:empty?).and_return(true)
      end
      it 'returns false' do
        expect(board_valid_start_field.valid_start_field?(start_field, current_player)).to be false
      end
    end
  end

  describe '#clear_way?' do
    subject(:board_clear_way){described_class.new}
    let(:position_inbetween){[[6,0],[5,0]]}

    context 'when positions_inbetween are not occupied' do
      it 'returns true' do
        board_clear_way.board[6,0].piece = nil
        expect(board_clear_way.clear_way?(position_inbetween)).to be true
      end
    end

    context 'when at least one field inbetween is occupied' do
      it 'retruns false' do
        expect(board_clear_way.clear_way?(position_inbetween)).to be false
      end
    end
  end
  
  describe '#valid_end_field?' do
    subject(:board_valid_end_field){described_class.new}
    let(:current_player){double('Player', color: :white)}
    context 'when moving_piece is not a pawn or it is a pawn doing a normal move' do
      let(:moving_piece){double('Rook', color: :white)}
      context 'when destination field is occupied by current player' do
        let(:end_field){board_valid_end_field.board[7,0]}
        it 'returns false' do
          expect(board_valid_end_field.valid_end_field?(moving_piece, end_field, current_player)).to be false
        end
      end

      context 'when destination is not occupied' do
        let(:end_field){board_valid_end_field.board[3,3]}
        it 'returns true' do
          expect(board_valid_end_field.valid_end_field?(moving_piece, end_field, current_player)).to be true
        end
      end

      context 'when destination is occupied by an opponent' do
        let(:end_field){board_valid_end_field.board[1,0]}
        it 'returns true' do
          expect(board_valid_end_field.valid_end_field?(moving_piece, end_field, current_player)).to be true
        end
      end
    end

    context 'when moving_piece is a pawn doing a taking' do
      let(:moving_piece){double('Pawn', color: :white, position: [6,0])}
      context 'when destination field is not occupied by opponent player' do
        let(:end_field){board_valid_end_field.board[5,1]}
        before do
          allow(moving_piece).to receive(:instance_of?).and_return(true)
          allow(moving_piece).to receive(:taking?).and_return true
          allow(end_field).to receive(:occupies_opponent_piece?).and_return false  
        end

        it 'returns false' do
          expect(board_valid_end_field.valid_end_field?(moving_piece, end_field, current_player)).to be false
        end
      end

      context 'when destination is occupied by opponent player' do
        it 'returns true' do
          board_valid_end_field.board[5,1].piece = double('Pawn', color: :black, position: [5,1])
          end_field = board_valid_end_field.board[5,1]
          expect(board_valid_end_field.valid_end_field?(moving_piece, end_field, current_player)).to be true
        end
      end
    end

  end

  describe '#valid_move?' do
    let(:current_player){double('Player', color: :white)}
    subject(:board_valid_move){described_class.new}
    context 'when start_field contains current players piece' do
      let(:start_field){board_valid_move.board[7,0]}
      let(:moving_piece){start_field.piece}
      context 'when destination is reachable and no piece is in the way' do
        before do
          allow(moving_piece).to receive(:chosen_destination_reachable?).and_return(true)
          allow(board_valid_move).to receive(:clear_way?).and_return(true)
        end
        context 'when end_field is empty' do
          it 'returns true' do
            end_field = board_valid_move.board[3,0]
            board_valid_move.board[6,0].piece = nil
            expect(board_valid_move.valid_move?(start_field, end_field, current_player)).to be true
          end
        end

        context 'when end_field is occupied by an opponent' do
          it 'returns true' do
            end_field = board_valid_move.board[1,0]
            board_valid_move.board[6,0].piece = nil
            expect(board_valid_move.valid_move?(start_field, end_field, current_player)).to be true
          end
        end

        context 'when end_field is occupied by current player' do
          it 'returns false' do
            end_field = board_valid_move.board[6,0]
            expect(board_valid_move.valid_move?(start_field, end_field, current_player)).to be false
          end
        end
      end

      context 'when destination is reachable but a piece is in the way' do
        before do
          allow(moving_piece).to receive(:chosen_destination_reachable?).and_return(true)
          allow(board_valid_move).to receive(:clear_way?).and_return(false)
        end
        it 'returns false' do
          end_field = board_valid_move.board[5,0]
          expect(board_valid_move.valid_move?(start_field, end_field, current_player)).to be false
        end
      end

      context 'when destination is not reachable' do
        before do
          allow(moving_piece).to receive(:chosen_destination_reachable?).and_return(false)
        end
        it 'returns false' do
          end_field = board_valid_move.board[5,0]
          expect(board_valid_move.valid_move?(start_field, end_field, current_player)).to be false
        end
      end
    end
  
    context 'when start_field is invalid' do
      let(:end_field){board_valid_move.board[3,2]}
      context 'when start_field is empty' do
        let(:start_field){board_valid_move.board[3,2]}
        it 'returns false' do
          allow(board_valid_move).to receive(:valid_start_field).and_return(false)
          expect(board_valid_move.valid_move?(start_field, end_field, current_player)).to be false
        end
      end

      context 'when start_field occupies opponent piece' do
        before do
          end
        it 'returns false' do
          start_field = board_valid_move.board[1,1]
          allow(board_valid_move).to receive(:valid_start_field).and_return(false)
          expect(board_valid_move.valid_move?(start_field, end_field, current_player)).to be false
        end
      end
    end
  end

  describe '#pieces_able_to_reach_field' do
    subject(:board_pieces_reach_field){described_class.new}
    context 'when piece_color is black' do
      let(:color){:black}
      let(:destination_field){board_pieces_reach_field.board[2,3]}

      it 'returns and array of black pieces, which can reach the destination_field' do
        # the destination is [2,3], as the field [1,4], the rook on [0,5] and the pawn on [1,3] can reach the destination
        board_pieces_reach_field.board[1,4].piece = nil
        solution = [board_pieces_reach_field.board[0,5].piece, board_pieces_reach_field.board[1,2].piece]
        expect(board_pieces_reach_field.pieces_able_to_reach_field(destination_field, color)).to match(solution)
      end
    end
  end

  describe '#king_can_escape' do
    subject(:board_king_escape){described_class.new}
    context 'when king is surrounded by its own pieces and therefore cant move' do
      before do
        board_king_escape.board[5,5].piece = double('Knight', position: [5,5], color: :black)
        allow(king).to receive(:next_movements)
        allow(board_king_escape).to receive(:empty?).and_return false
        allow(board_king_escape).to receive(:occupies_opponent_piece?).and_return false
        allow(board_king_escape).to receive(:pieces_able_to_reach_field).and_return []
      end
      xit 'returns false' do
        king = board_king_escape.board[7,4].piece
        expect(board_king_escape.king_can_escape?(king))
      end
    end

    context 'when king can move to at least one field next to it' do
      context 'when that field is reachable by an opponents piece' do
        xit 'returns true' do
          
        end
      end
      
      context 'when that field is not reachable by an opponents piece' do
        xit 'returns false' do
          
        end
      end
    end
  end
end
