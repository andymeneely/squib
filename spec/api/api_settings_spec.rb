require 'spec_helper'

describe Squib::Deck do
  context '#hint' do
    it 'sets hinting to conf' do
      mock_conf = double(Squib::Conf)
      expect(mock_conf).to receive(:text_hint=).with(:cyan).once
      Squib::Deck.new do
        @conf = mock_conf
        hint text: :cyan
      end
    end
  end
end
