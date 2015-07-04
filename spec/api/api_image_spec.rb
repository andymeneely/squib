require 'spec_helper'
require 'squib'

describe Squib::Deck, 'images' do
  context '#png' do
    it 'calls Card#png, Dir, and progress bar' do
      card = instance_double(Squib::Card)
      progress = double(Squib::Progress)
      expect(card).to receive(:png).with('foo', 0, 1, :native, :native, 0.5, :overlay, 0.75, nil).once
      expect(Dir).to receive(:chdir).with('.').and_yield.once
      expect(progress).to receive(:start).and_yield(progress).once
      expect(progress).to receive(:increment).once
      Squib::Deck.new do
        @progress_bar = progress
        @cards = [card]
        png file: 'foo', x: 0, y: 1, alpha: 0.5, blend: :overlay, angle: 0.75
      end
    end
  end

  context '#svg' do
    it 'calls Card#svg, Dir, and progress bar' do
      card = instance_double(Squib::Card)
      progress = double(Squib::Progress)
      expect(card).to receive(:svg).with('foo', nil, '#bar', 0, 1, 20, 30, 0.5, :overlay, 0.75, nil).once
      expect(Dir).to receive(:chdir).with('.').and_yield.once
      expect(progress).to receive(:start).and_yield(progress).once
      expect(progress).to receive(:increment).once
      Squib::Deck.new do
        @progress_bar = progress
        @cards = [card]
        svg file: 'foo', id: 'bar', x: 0, y: 1, width: 20, height: 30, alpha: 0.5, blend: :overlay, angle: 0.75
      end
    end
  end
end
