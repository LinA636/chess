require_relative "../lib/chessGame"

describe ChessGame do
  
  describe "#get_start_end_field" do
    subject(:game){described_class.new}
    let(:occupied_start){'a2a3'}
    before do
      allow(game).to receive(:get_valid_move_pattern).and_return(occupied_start)
    end

    context 'when start field is occupied' do
      it 'returns start and end field' do
        start_field = game.chess_board.board[6,0]
        end_field = game.chess_board.board[5,0]

        expect(game.get_start_end_field).to match([start_field, end_field])
      end
    end
  end

  describe '#valid_input_pattern' do
    subject(:game_input_pattern){described_class.new}
    let(:valid_input){'a1a2'}
    let(:invalid_input){'i9a2'}
    context 'when pattern is invalid' do
      it 'returns false' do
        expect(game_input_pattern.valid_input_pattern?(invalid_input)).to be false
      end    
    end

    context 'when pattern is valid' do
      it 'returns true' do
        expect(game_input_pattern.valid_input_pattern?(valid_input)).to be true
      end
    end
  end

end