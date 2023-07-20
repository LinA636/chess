require_relative "../lib/chessBoard"
require_relative "../lib/field"

describe ChessBoard do
  describe '#occupies_piece?' do
    subject(:board){described_class.new}
    before do
      allow(board).to receive(:get_field).with("d5").and_return(*field)
    end
    context 'when field is not occupied' do
      let(:field){Field.new("d5")}
      it 'returns false' do
        expect(board.occupies_piece?).to be false
      end
    end

    context 'when field is occupied' do
      xit 'returns true'do
        
      end
    end
  end
end