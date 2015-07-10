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

  context '#set' do

    it 'puts font in @font' do
      deck = Squib::Deck.new do
        set font: 'foo'
      end
      expect(deck.font).to eq ('foo')
    end

    it 'raises deprecation errors on img_dir' do
      set_img_dir = Proc.new do
        Squib::Deck.new do
          set img_dir: 'foo'
        end
      end
      expect { set_img_dir.call }.to raise_error('DEPRECATED: As of v0.7 img_dir is no longer supported in "set". Use config.yml instead.')
    end

  end

end