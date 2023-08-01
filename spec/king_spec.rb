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

  describe '#chosen_destination_reachable?' do
    subject(:piece) {described_class.new(:white, [1, 3]) }
    context 'when the destination is avalid next_movement' do
      it "returns true" do
        end_field = Field.new("c5", [1,4])
        expect(piece.chosen_destination_reachable?(end_field)).to be true
      end
    end

    context "when the destination is an invalid movement" do
      it "returns false" do
        end_field = Field.new("e7", [1,5])
        expect(piece.chosen_destination_reachable?(end_field)).to be false
      end
    end
  end

  describe '#get_field_positions_on_way' do
    subject(:king) { described_class.new(:white, [3,2]) }
    context 'when the field is reachable' do
      it 'returns empty array'do
        destination_field = Field.new("a2", [3,3])
        expect(king.get_field_positions_on_way(destination_field)).to match_array([])
      end
    end

    context "when the end field is not reachable" do
      it "returns nil for an unreachable end field" do
        destination_field = Field.new("a2", [1,3])
        # The end field is [1,3], but it is not reachable from the current position
        expect(king.get_field_positions_on_way(destination_field)).to be_nil
      end
    end
  end
end