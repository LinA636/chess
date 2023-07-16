require_relative "../lib/king"

describe King do
  describe '#initialize' do
    context 'when color is white' do
      subject(:piece){described_class.new(:white,[1,2])}

      it 'sets the color, symbol and position' do
        expect(piece.color).to eq(:white)
        expect(piece.symbol).to eq("\u{2654}")
        expect(piece.position).to eq([1,2])
        expect(piece.captured).to be false
        expect(piece.first_move_done).to be false
      end
    end

    context 'when color is black' do
      subject(:piece){described_class.new(:black,[0,0])}

      it 'sets the color, symbol and position' do
        expect(piece.color).to eq(:black)
        expect(piece.symbol).to eq("\u{265A}")
        expect(piece.position).to eq([0,0])
        expect(piece.captured).to be false
        expect(piece.first_move_done).to be false
      end
    end
  end

  describe '#next_movements' do
    context 'when piece is in the left top corner' do
      subject(:piece_moving){described_class.new(:white,[0,0])}

      it 'returns valid next movements' do
        expected_movements = [[0,1],[1,0],[1,1]]
        expect(piece_moving.next_movements).to match_array(expected_movements)
      end
    end

    context 'when piece in the middle of the board' do
      subject(:piece_moving){described_class.new(:black,[3,3])}

      it 'returns valid next movements' do
        expected_movements = [[2,2],[2,3],[2,4],[3,2],[3,4],[4,2],[4,3],[4,4]]
        expect(piece_moving.next_movements).to match_array(expected_movements)
      end
    end
  end
end