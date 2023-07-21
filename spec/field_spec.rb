require_relative "../lib/field"

describe Field do
  subject(:field){described_class.new("e4",[0,0])}
  describe '#occupies_piece?' do
    context 'when field is not occupied' do
      it 'returns false' do
        expect(field.occupies_piece?).to be false
      end
    end

    context 'when field is occupied by a piece' do
      it 'returns true'do
        field.piece = Pawn.new(:white, [1, 0])
        expect(field.occupies_piece?).to be true
      end
    end
  end

  describe '#occuppies_cp_piece?' do
    context 'when the field is occupied by a piec of the ccurrent player' do
     it 'returns true' do
        field.piece = Pawn.new(:white, [1, 0])
        current_player = double("Player", color: :white)
        expect(field.occupies_cp_piece?(current_player)).to be true
      end
    end

    context 'when the field is occupied by a piece of the opponent' do
      it 'returns false' do
        current_player = double("Player", color: :white)
        expect(field.occupies_cp_piece?(current_player)).to be false
      end
    end

    context 'when the field is not occupied' do
      it 'returns false' do
        current_player = double("Player", color: :black)
        expect(field.occupies_cp_piece?(current_player)).to be false
      end
    end
  end

  describe '#end_destination_reachable?' do
    
  end
end