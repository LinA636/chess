require_relative "../lib/main"

  describe '#get_game_mode' do
    before do
      allow(get_game_mode).to receive(:gets).and_return(*inputs)
    end

    context 'when current_player inputs "start"' do
      let(:inputs){["start\n"]}

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

    context 'when current_player inputs invalid input' do
      let(:inputs){["invalid\n", "start\n"]}
      it 'calls #get_game_mode and returns valid input "start"' do
        expect(game.get_game_mode).to eq("start")
      end
    end


end