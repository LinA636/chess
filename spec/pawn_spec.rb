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

  describe '#taking?' do
    subject(:pawn_taking){described_class.new(:white, [6,2])}
    context 'when end_field is included in taking_movements' do
      let(:end_field){double('Field', position: [5,1])}
      it 'returns true' do
        expect(pawn_taking.taking?(end_field)).to be true
      end
    end

    context 'when end_field is not included in taking_movements' do
      let(:end_field){double('Field', position: [5,2])}
      it 'returns false' do
        expect(pawn_taking.taking?(end_field)).to be false
      end
    end
  end

  describe '#chosen_destination_reachable?' do
    subject(:white_pawn) {described_class.new(:white, [1, 3]) }
    subject(:black_pawn) { described_class.new(:black, [6, 4]) }
    context "when the pawn is white" do
      context 'when the destination is avalid next_movement' do
        it "returns true" do
          end_field = Field.new("c5", [0,3])
          expect(white_pawn.chosen_destination_reachable?(end_field)).to be true
        end
      end
      
      context 'when the destination is a valid taking_movement' do
        it 'retruns true' do
          end_field = Field.new("c5", [0,2])
          expect(white_pawn.chosen_destination_reachable?(end_field)).to be true
        end
      end   

      context "when the destination is an invalid movement" do
        it "returns false" do
          end_field = Field.new("e7", [0,0])
          expect(white_pawn.chosen_destination_reachable?(end_field)).to be false
        end
      end   
    end

    context 'when the pawn is black' do
      context "when the destination is a valid next_movement" do
        it "returns true" do
          end_field = Field.new("d3", [7,4])
          expect(black_pawn.chosen_destination_reachable?(end_field)).to be true
        end
      end

      context 'when the destination is a valid taking_movement' do
        it 'retruns true' do
          end_field = Field.new("c5", [7,5])
          expect(black_pawn.chosen_destination_reachable?(end_field)).to be true
        end
      end

      context "when the destination is an invalid taking movement" do
        it "returns false" do
          end_field = Field.new("d1",[0,0]) 
          expect(white_pawn.chosen_destination_reachable?(end_field)).to be false
        end
      end
    end
  end

  describe "#get_field_positions_on_way" do
    subject(:white_pawn) { described_class.new(:white, [6, 3]) }
    subject(:black_pawn) { described_class.new(:black, [1, 3]) }

    context "for a white pawn" do
      before do
        allow(white_pawn).to receive(:next_movements).and_return([[5, 3], [4, 3]])
      end

      context 'when destination is included in next_movements' do
        it "returns an array with the field positions between the current field and the end field when moving two steps" do
          white_pawn.first_move_done = false
          destination_field = Field.new("a1", [4, 3])
          # The end field is [4, 3], and the positions between [4, 3] and [6, 3] are [5, 3]
          expect(white_pawn.get_field_positions_on_way(destination_field)).to eq([[5, 3]])
        end

        it "returns an empty array when moving one steps" do
          white_pawn.first_move_done = true
          destination_field = Field.new("a1", [5, 3])
          # The end field is [5, 3], but there are no positions between [6, 3] and [5, 3]
          expect(white_pawn.get_field_positions_on_way(destination_field)).to eq([])
        end
      end
    end


    context "for a black pawn" do
      before do
        allow(black_pawn).to receive(:next_movements).and_return([[2, 3], [3, 3]])
      end

      it "returns an array with the field positions between the current field and the end field when moving two steps" do
        black_pawn.first_move_done = false
        destination_field = Field.new("a1", [3, 3])
        # The end field is [3, 3], and the positions between [1, 3] and [3, 3] are [2, 3]
        expect(black_pawn.get_field_positions_on_way(destination_field)).to eq([[2, 3]])
      end

      it "returns an empty array when moving two steps" do
        black_pawn.first_move_done = true
        destination_field = Field.new("a1", [2, 3])
        # The end field is [1, 3], but there are no positions between [1, 3] and [2, 3]
        expect(black_pawn.get_field_positions_on_way(destination_field)).to eq([])
      end
    end
  end

end