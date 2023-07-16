require_relative "../lib/knight"

describe Knight do
  describe '#initialize' do
    context 'when color is white' do
      subject(:piece){described_class.new(:white,[1,2])}

      it 'sets the color, symbol and position' do
        expect(piece.color).to eq(:white)
        expect(piece.symbol).to eq("\u{2658}")
        expect(piece.position).to eq([1,2])
        expect(piece.captured).to be false
      end
    end

    context 'when color is black' do
      subject(:piece){described_class.new(:black,[0,0])}

      it 'sets the color, symbol and position' do
        expect(piece.color).to eq(:black)
        expect(piece.symbol).to eq("\u{265E}")
        expect(piece.position).to eq([0,0])
        expect(piece.captured).to be false
      end
    end
  end

  describe '#next_movements' do
    context 'when piece is in the middle of the board' do
      subject(:piece_moving){described_class.new(:white,[3,3])}

      it 'returns two valid next movements, when first move is not done' do
        expected_movements = [[1,2], [1,4], [2,1], [2,5], [4,1],[4,5],[5,2],[5,4]]
        expect(piece_moving.next_movements).to eq(expected_movements)
      end
    end

    context 'when piece on the left side of the board' do
      subject(:piece_moving){described_class.new(:black,[3,0])}

      it 'returns two valid next movements, when first move is not done' do
        expected_movements = [[1,1],[2,2],[4,2],[5,1]]
        expect(piece_moving.next_movements).to eq(expected_movements)
      end
    end
  end
end