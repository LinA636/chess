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

  describe '#chosen_destination_reachable?' do
    subject(:white_piece) {described_class.new(:white, [1, 3]) }
    context 'when the destination is avalid next_movement' do
      it "returns true" do
        end_field = Field.new("c5", [2,4])
        expect(white_piece.chosen_destination_reachable?(end_field)).to be true
      end
    end 

    context "when the destination is an invalid movement" do
      it "returns false" do
        end_field = Field.new("e7", [0,0])
        expect(white_piece.chosen_destination_reachable?(end_field)).to be false
      end
    end   
  end

  describe "#get_field_positions_on_way" do
    subject(:bishop) { described_class.new(:white, [4,5]) }

    context "when bishop is moving diagonally upwards to the left" do
      it "returns an array with the field position between the current field and the end field" do
        destination_field = Field.new("a1", [1,2])
        # The end field is [1,2], and the positions between [4,5] and [1,2] are [2,3] [3,4]
        expect(bishop.get_field_positions_on_way(destination_field)).to match_array([[2,3] ,[3,4]])
      end
    end

    context "when bishop is moving diagonally upwards to the right" do
      it "returns an array with the field position between the current field and the end field" do
        destination_field = Field.new("a1", [2,7])
        # The end field is [2,7], and the positions between [4,5] and [2,7] are [3,6]
        expect(bishop.get_field_positions_on_way(destination_field)).to match_array([[3,6]])
      end
    end
    
    context "when bishop is moving diagonally downwards to the left" do
      it "returns an array with the field position between the current field and the end field" do
        destination_field = Field.new("a1", [7,2])
        # The end field is [7,2], and the positions between [4,5] and [7,2] are [5,4], [6,3]
        expect(bishop.get_field_positions_on_way(destination_field)).to match_array([[5,4], [6,3]])
      end
    end  
    
    context "when bishop is moving diagonally downwards to the right" do
      it "returns an array with the field position between the current field and the end field" do
        destination_field = Field.new("a1", [6,7])
        # The end field is [6,7], and the positions between [4,5] and [6,7] are [5,6]
        expect(bishop.get_field_positions_on_way(destination_field)).to match_array([[5,6]])
      end
    end 

    context "when the end field is not reachable" do
      it "returns nil for an unreachable end field" do
        destination_field = Field.new("a2", [7,7])
        # The end field is [7,7], but it is not reachable from the current position
        expect(bishop.get_field_positions_on_way(destination_field)).to be_nil
      end
    end
  end
end