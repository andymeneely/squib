require 'squib/deck'
require 'spec_helper'

describe Squib::Deck do
  let(:deck) { Squib::Deck.new }

  context '#save' do
    it 'delegates to both based on format options: :pdf, :png' do
      expect(deck).to receive(:save_png).once.with({ prefix: 'foo' })
      expect(deck).to receive(:save_pdf).once.with({ prefix: 'foo' })
      deck.save format: [:png, :pdf], prefix: 'foo'
    end

    it 'delegates to just pdf based on format options: :pdf' do
      expect(deck).to receive(:save_pdf).once.with({ prefix: 'foo' })
      deck.save format: :pdf, prefix: 'foo'
    end

    it 'delegates to just png based on format options: :png' do
      expect(deck).to receive(:save_png).once.with({ prefix: 'foo' })
      deck.save format: :png, prefix: 'foo'
    end

    it 'warns on :svg' do
      expect(deck).to receive(:save_png).once.with({ prefix: 'foo' })
      expect(deck).to receive(:save_pdf).once.with({ prefix: 'foo' })
      expect(deck).to receive(:warn).once
      deck.save format: [:png, :svg, :pdf], prefix: 'foo'
    end

  end
end
