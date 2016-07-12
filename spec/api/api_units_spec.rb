require 'spec_helper'

describe Squib::Deck do

  let(:deck) { Squib::Deck.new }

  context '#in' do
    it 'converts inches properly' do
      expect(deck.inches(1)).to eq 300
    end

    it 'handles strings too' do
      expect(deck.inches('1')).to eq 300
    end
  end

  context '#cm' do
    it 'converts inches properly' do
      expect(deck.cm(1)).to eq 118.1102361
    end

    it 'handles strings too' do
      expect(deck.cm('1')).to eq 118.1102361
    end
  end

  context '#mm' do
    it 'converts inches properly' do
      expect(deck.mm(1)).to eq 11.81102361
    end

    it 'handles strings too' do
      expect(deck.mm('1')).to eq 11.81102361
    end
  end

end
