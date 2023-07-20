require_relative "../lib/main"

describe Main do
  describe '#get_game_mode' do
    subject(:game){described_class.new}
    before do
      allow(game).to receive(:gets).and_return(*inputs)
    end

    context 'when current_player inputs "STart"' do
      let(:inputs){["STart\n"]}

      it 'returns "start"' do
        expect(game.get_game_mode).to eq('start')
      end
    end

    context 'when current_player inputs "resume"' do
      let(:inputs){["resume\n"]}
      it 'returns "resume"' do
        expect(game.get_game_mode).to eq('resume')
      end
    end

    context 'when current_player inputs "exit"' do
      let(:inputs){["exit\n"]}
      it 'returns "resume"' do
        expect(game.get_game_mode).to eq('resume')
      end
    end

    context 'when current_player inputs invalid input' do
      let(:inputs){["invalid\n", "start\n"]}
      it 'calls #get_game_mode and returns valid input "start"' do
        expect(game.get_game_mode).to eq("start")
      end
    end

  end
end