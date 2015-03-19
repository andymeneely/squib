require 'spec_helper'
require 'squib'

describe Squib::Deck, '#text' do

  context 'fonts' do
     it "should use the default font when #text and #set_font don't specify" do
      card = instance_double(Squib::Card)
      expect(card).to receive(:text).with(anything, 'a', 'Arial 36', *([anything] * 15)).once
      Squib::Deck.new do
        @cards = [card]
        text str: 'a'
      end
    end

    it "should use the #set_font when #text doesn't specify" do
      card = instance_double(Squib::Card)
      expect(card).to receive(:text).with(anything, 'a', 'Times New Roman 16', *([anything] * 15)).once
      Squib::Deck.new do
        @cards = [card]
        set font: 'Times New Roman 16'
        text str: 'a'
      end
    end

    it 'should use the specified font no matter what' do
      card = instance_double(Squib::Card)
      expect(card).to receive(:text).with(anything, 'a', 'Arial 18', *([anything] * 15)).once
      Squib::Deck.new do
        @cards = [card]
        set font: 'Times New Roman 16'
        text str: 'a', font: 'Arial 18'
      end
    end
  end

end
