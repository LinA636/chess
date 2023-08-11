require_relative "../lib/queen"

describe Queen do
  describe '#initialize' do
    context 'when color is white' do
      subject(:piece){described_class.new(:white,[1,2])}

      it 'sets the color, symbol and position' do
        expect(piece.color).to eq(:white)
        expect(piece.symbol).to eq("\u{2655}")
        expect(piece.position).to eq([1,2])
        expect(piece.captured).to be false
      end
    end

    context 'when color is black' do
      subject(:piece){described_class.new(:black,[0,0])}

      it 'sets the color, symbol and position' do
        expect(piece.color).to eq(:black)
        expect(piece.symbol).to eq("\u{265B}")
        expect(piece.position).to eq([0,0])
        expect(piece.captured).to be false
      end
    end
  end

  describe '#next_movements' do
    context 'when piece is in the left top corner' do
      subject(:piece_moving){described_class.new(:white,[0,0])}

      it 'returns valid next movements' do
        expected_movements = [[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0], [0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7],
                                [1,1],[2,2],[3,3],[4,4],[5,5],[6,6],[7,7]]
        expect(piece_moving.next_movements).to match_array(expected_movements)
      end
    end

    context 'when piece in the middle of the board' do
      subject(:piece_moving){described_class.new(:black,[3,3])}

      it 'returns valid next movements' do
        expected_movements = [[3,0],[3,1],[3,2],[3,4],[3,5],[3,6],[3,7],[0,3],[1,3],[2,3],[4,3],[5,3],[6,3],[7,3],
                              [0,0],[1,1],[2,2],[4,4],[5,5],[6,6],[7,7], [6,0],[5,1],[4,2],[2,4],[1,5],[0,6]]
        expect(piece_moving.next_movements).to match_array(expected_movements)
      end
    end
  end

  describe '#chosen_destination_reachable?' do
    subject(:piece) {described_class.new(:white, [1, 3]) }
    context 'when the destination is avalid next_movement' do
      it "returns true" do
        end_field = Field.new("c5", [1,7])
        expect(piece.chosen_destination_reachable?(end_field)).to be true
      end
    end

    context "when the destination is an invalid movement" do
      it "returns false" do
        end_field = Field.new("e7", [3,4])
        expect(piece.chosen_destination_reachable?(end_field)).to be false
      end
    end
  end

  describe '#get_field_positions_on_way' do
    describe "#get_field_positions_on_way" do
      subject(:queen) { described_class.new(:white, [3,3]) }
      
      context "when queen is moving diagonally upwards to the left" do
        it "returns an array with the field position between the current field and the end field" do
          destination_field = Field.new("a1", [1,1])
          # The end field is [1,1], and the positions between [3,3] and [1,1] are [2,2]
          expect(queen.get_field_positions_on_way(destination_field)).to match_array([[2,2]])
        end
      end

      context "when queen is moving upwards" do
        it "returns an array with the field position between the current field and the end field" do
          destination_field = Field.new("a1", [0,3])
          # The end field is [0,3], and the positions between [3,3] and [0,3] are [1,3] [2,3]
          expect(queen.get_field_positions_on_way(destination_field)).to match_array([[2,3] ,[1,3]])
        end
      end
  
      context "when queen is moving diagonally upwards to the right" do
        it "returns an array with the field position between the current field and the end field" do
          destination_field = Field.new("a1", [1,5])
          # The end field is [1,5], and the positions between [3,3] and [1,5] are [2,4]
          expect(queen.get_field_positions_on_way(destination_field)).to match_array([[2,4]])
        end
      end

      context "when queen is moving to the right" do
        it "returns an array with the field position between the current field and the end field" do
          destination_field = Field.new("a1", [3,6])
          # The end field is [3,6], and the positions between [3,3] and [3,6] are [3,5] [3,4]
          expect(queen.get_field_positions_on_way(destination_field)).to match_array([[3,5] ,[3,4]])
        end
      end
      
      context "when queen is moving diagonally downwards to the right" do
        it "returns an array with the field position between the current field and the end field" do
          destination_field = Field.new("a1", [6,6])
          # The end field is [6,6], and the positions between [3,3] and [6,6] are [4,4] [5,5]
          expect(queen.get_field_positions_on_way(destination_field)).to match_array([[4,4] ,[5,5]])
        end
      end 
  
      context "when queen is moving downwards" do
        it "returns an array with the field position between the current field and the end field" do
          destination_field = Field.new("a1", [5,3])
          # The end field is [5,3], and the positions between [3,3] and [5,3] are [4,3]
          expect(queen.get_field_positions_on_way(destination_field)).to match_array([[4,3]])
        end
      end

      context "when queen is moving diagonally downwards to the left" do
        it "returns an array with the field position between the current field and the end field" do
          destination_field = Field.new("a1", [5,1])
          # The end field is [3,3], and the positions between [3,3] and [5,1] are [4,2]
          expect(queen.get_field_positions_on_way(destination_field)).to match_array([[4,2]])
        end
      end  

      context "when queen is moving downwards" do
        it "returns an array with the field position between the current field and the end field" do
          destination_field = Field.new("a1", [3,1])
          # The end field is [3,3], and the positions between [3,3] and [3,1] are [2,3] [3,4]
          expect(queen.get_field_positions_on_way(destination_field)).to match_array([[3,2]])
        end
      end
    end
  end

end