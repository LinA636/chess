require_relative "../lib/bishop"

describe Bishop do
  describe '#initialize' do
    context 'when color is white' do
      subject(:piece){described_class.new(:white,[1,2])}

      it 'sets the color, symbol and position' do
        expect(piece.color).to eq(:white)
        expect(piece.symbol).to eq("\u{2657}")
        expect(piece.position).to eq([1,2])
        expect(piece.captured).to be false
      end
    end

    context 'when color is black' do
      subject(:piece){described_class.new(:black,[0,0])}

      it 'sets the color, symbol and position' do
        expect(piece.color).to eq(:black)
        expect(piece.symbol).to eq("\u{265D}")
        expect(piece.position).to eq([0,0])
        expect(piece.captured).to be false
      end
    end
  end

  describe '#next_movements' do
    context 'when piece is in the left bottom corner' do
      subject(:piece_moving){described_class.new(:white,[7,0])}

      it 'returns valid next movements' do
        expected_movements = [[6,1], [5,2],[4,3],[3,4],[2,5],[1,6],[0,7]]
        expect(piece_moving.next_movements).to match_array(expected_movements)
      end
    end

    context 'when piece in the middle of the board' do
      subject(:piece_moving){described_class.new(:black,[3,3])}

      it 'returns valid next movements' do
        expected_movements = [[0,0],[1,1],[2,2],[4,4],[5,5],[6,6],[7,7],[6,0],[5,1],[4,2],[2,4],[1,5],[0,6]]
        expect(piece_moving.next_movements).to match_array(expected_movements)
      end
    end
  end
end