require_relative "../lib/chessBoard"

describe ChessBoard do
  subject(:board){described_class.new}
  describe '#occupies_piece?' do
    context 'when field is not occupied' do
      it 'returns false' do
        field = Field.new("e4")
        expect(board.occupies_piece?(field)).to be false
      end
    end

    context 'when field is occupied by a piece' do
      it 'returns true'do
        field = Field.new("a2")
        field.piece = Pawn.new(:white, [1, 0])
        expect(board.occupies_piece?(field)).to be true
      end
    end
  end

  describe '#occuppies_cp_piece?' do
    context 'when the field is occupied by a piec of the ccurrent player' do
      it 'returns true' do
        field = Field.new("a2")
        field.piece = Pawn.new(:white, [1, 0])
        current_player = double("Player", color: :white)
        expect(board.occupies_cp_piece?(field, current_player)).to be true
      end
    end

    context 'when the field is occupied by a piece of the opponent' do
      it 'returns false' do
        field = Field.new("a7")
        field.piece = Pawn.new(:black, [6, 0])
        current_player = double("Player", color: :white)
        expect(board.occupies_cp_piece?(field, current_player)).to be false
      end
    end

    context 'when the field is not occupied' do
      it 'returns false' do
        field = Field.new("e4")
        current_player = double("Player", color: :black)
        expect(board.occupies_cp_piece?(field, current_player)).to be false
      end
    end
  end

  describe '#end_destination_reachable?' do
    
  end


end