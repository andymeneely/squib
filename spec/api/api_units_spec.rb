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

  context '#pt' do
    it 'converts inches properly' do
      expect(deck.points(1)).to eq 4.166666666666667
    end

    it 'handles strings too' do
      expect(deck.points('1')).to eq 4.166666666666667
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

  context '#cell(s)' do
    context 'when cell_size is not set' do
      it 'uses the default cell size' do
        expect(deck.cell(1)).to eq Squib::DEFAULT_CELL_SIZE
      end

      it 'handles strings too' do
        expect(deck.cells('2')).to eq 2 * Squib::DEFAULT_CELL_SIZE
      end
    end

    context 'when cell_size is set' do
      let(:cell_size) { 50 }
      let(:deck) { Squib::Deck.new(cell_size: cell_size) }

      it 'uses the configured cell size' do
        expect(deck.cell(1)).to eq(cell_size)
      end
    end
  end
end
