require_relative "../lib/pawn"

describe Pawn do
  describe '#initialize' do
    context 'when color is white' do
      subject(:pawn){described_class.new(:white,[1,2])}

      it 'sets the color, symbol and position' do
        expect(pawn.color).to eq(:white)
        expect(pawn.symbol).to eq("\u{2659}")
        expect(pawn.position).to eq([1,2])
        expect(pawn.captured).to be false
      end
    end

    context 'when color is black' do
      subject(:pawn){described_class.new(:black,[0,0])}

      it 'sets the color, symbol and position' do
        expect(pawn.color).to eq(:black)
        expect(pawn.symbol).to eq("\u{265F}")
        expect(pawn.position).to eq([0,0])
        expect(pawn.captured).to be false
      end
    end
  end

  describe '#next_movements' do
    context 'when pawn is white' do
      subject(:pawn_moving){described_class.new(:white,[8,1])}

      it 'returns two valid next movements, when first move is not done' do
        expected_movements = [[7,1], [6,1]]
        expect(pawn_moving.next_movements).to eq(expected_movements)
      end
  
      it 'returns one valid next movement, when first move is done' do
        pawn_moving.first_move_done = true
        expected_movements = [7,1]
        expect(pawn_moving.next_movements).to eq(expected_movements)
      end
    end

    context 'when pawn is black' do
      subject(:pawn_moving){described_class.new(:black,[0,1])}

      it 'returns two valid next movements, when first move is not done' do
        expected_movements = [[1,1], [2,1]]
        expect(pawn_moving.next_movements).to eq(expected_movements)
      end
  
      it 'returns one valid next movement, when first move is done' do
        pawn_moving.first_move_done = true
        expected_movements = [1,1]
        expect(pawn_moving.next_movements).to eq(expected_movements)
      end
    end

    context 'when the next move is not on the board' do
      subject(:pawn_moving){described_class.new(:white, [0,1])}

      it 'returns empty array' do
        expected_movements = []
        expect(pawn_moving.next_movements).to eq(expected_movements)
      end
    end
  end

  describe '#taking_movements' do
    context 'when pawn is white' do
      subject(:pawn_taking){described_class.new(:white,[8,1])}

      it 'returns two valid next movements' do
        expected_movements = [[7,2], [7,0]]
        expect(pawn_taking.taking_movements).to eq(expected_movements)
      end
    end

    context 'when pawn is black' do
      subject(:pawn_taking){described_class.new(:black,[0,1])}

      it 'returns two valid next movements' do
        expected_movements = [[1,0], [1,2]]
        expect(pawn_taking.taking_movements).to eq(expected_movements)
      end
    end

    context 'when the next move is not on the board' do
      subject(:pawn_moving){described_class.new(:white, [0,1])}

      it 'returns empty array' do
        expected_movements = []
        expect(pawn_moving.taking_movements).to eq(expected_movements)
      end
    end
  end
end