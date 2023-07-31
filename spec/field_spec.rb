require_relative "../lib/field"

describe Field do
  describe '#occupies_piece?' do
    subject(:field_occupied){described_class.new("a0",[0,0])}
    context 'when field is empty' do
      it 'returns false' do
        expect(field_occupied.occupies_piece?).to be false
      end
    end

    context 'when field is occupied by a piece' do
      let(:piece){double('Piece')}
      before do
        field_occupied.piece = piece
      end

      it 'returns true'do
        expect(field_occupied.occupies_piece?).to be true
      end
    end
  end

  describe '#occuppies_cp_piece?' do
    subject(:field_occupies_cp){described_class.new("a0",[0,0])}
    let(:white_player){double('Player', color: :white)}
    let(:black_player){double('Player', color: :black)}
    let(:current_player){white_player}
    context 'when the field is occupied by a piece of the current player' do
      let(:piece){double('Piece', color: :white)}
      before do
        field_occupies_cp.piece = piece
      end

      it 'returns true' do        
        expect(field_occupies_cp.occupies_cp_piece?(current_player)).to be true
      end
    end

    context 'when the field is occupied by a piece of the opponent' do
      let(:piece){double('Piece', color: :black)}
      it 'returns false' do
        expect(field_occupies_cp.occupies_cp_piece?(current_player)).to be false
      end
    end

    context 'when the field is empty' do
      it 'returns false' do
        expect(field_occupies_cp.occupies_cp_piece?(current_player)).to be false
      end
    end
  end

  describe '#empty?' do
    subject(:field_empty){described_class.new("a0", [0,0])}
    context 'when field is empty' do
      it 'returns true' do
        expect(field_empty.empty?).to be true
      end
    end

    context 'when field is occupied by a piece' do
      let(:piece){double('Piece')}
      before do
        field_empty.piece = piece
      end

      it 'returns false' do
        expect(field_empty.empty?).to be false
      end
    end
  end

  describe '#to_s' do
    subject(:field_to_s){described_class.new("a0", [0,0])}
    context 'when the field is empty' do
      it 'returns a space character' do
        field_to_s = Field.new(1, [0, 0])
        expect(field_to_s.to_s).to eq(' ')
      end
    end

    context 'when the field is occupied by a piece' do
      let(:piece){double('Piece', symbol: 'P')}
      before do
        field_to_s.piece = piece
      end

      it 'returns the piece symbol' do
        expect(field_to_s.to_s).to eq(piece)
      end
    end
  end

end