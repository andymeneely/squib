require 'spec_helper'
require 'squib'

describe Squib::Deck do

  it 'initializes with default parameters' do
    d = Squib::Deck.new
    expect(d.width).to eq(825)
    expect(d.height).to eq(1125)
    expect(d.cards.size).to eq(1)
  end

  it 'can be built with unit conversion' do
    d = Squib::Deck.new(width: '1in', height: '2in')
    expect(d.width).to eq(300)
    expect(d.height).to eq(600)
  end

  context 'in dealing with ranges' do
    it 'calls text on all cards by default' do
      card1 = instance_double(Squib::Card)
      card2 = instance_double(Squib::Card)
      expect(card1).to receive(:text).once
      expect(card2).to receive(:text).once
      expect(card1).to receive(:finish!).once
      expect(card2).to receive(:finish!).once
      Squib::Deck.new do
        @cards = [card1, card2]
        text str: 'blah'
      end
    end

    it 'calls text on some cards with an integer' do
      card1 = instance_double(Squib::Card)
      card2 = instance_double(Squib::Card)
      expect(card1).to receive(:finish!).once
      expect(card2).to receive(:text).once
      expect(card2).to receive(:finish!).once
      Squib::Deck.new do
        @cards = [card1, card2]
        text range: 1, str: 'blah'
      end
    end

    it 'calls text with ranges' do
      card1 = instance_double(Squib::Card)
      card2 = instance_double(Squib::Card)
      card3 = instance_double(Squib::Card)
      expect(card1).to receive(:text).once
      expect(card1).to receive(:finish!).once
      expect(card2).to receive(:text).once
      expect(card2).to receive(:finish!).once
      expect(card3).to receive(:finish!).once
      Squib::Deck.new do
        @cards = [card1, card2, card3]
        text range: 0..1, str: 'blah'
      end
    end
  end

  it 'loads a normal layout with no extends' do
    d = Squib::Deck.new(layout: layout_file('no-extends.yml'))
    expect(d.layout).to eq({
      'frame' => {
        'x' => 38,
        'valign' => :middle,
        'str' => 'blah',
        'font' => 'Mr. Font',
      }
    })
  end

end
