# typed: false
require 'spec_helper'
require 'squib/args/scale_box'

describe Squib::Args::ScaleBox do
  let(:deck) { OpenStruct.new(width: 123, height: 456, size: 1, dpi: 300.0) }

  context 'unit conversion' do
    it 'converts units on all args' do
      deck_w_2 = OpenStruct.new(width: 123, height: 456, size: 2, dpi: 300.0)
      args = { x: ['1in', '2in'], y: 300, width: '1in', height: '1in' }
      box = Squib::Args.extract_scale_box args, deck_w_2
      expect(box).to have_attributes(
        x: [300, 600],
        y: [300, 300],
        width: [300, 300],
        height: [300, 300],
      )
    end
  end

  context 'validation' do
    it 'replaces with deck width and height' do
      args = { width: :deck, height: :deck }
      box = Squib::Args.extract_scale_box args, deck
      expect(box).to have_attributes(width: [123], height: [456])
    end

    it 'allows :native' do
      args = { width: :native, height: :native }
      box = Squib::Args.extract_scale_box args, deck
      expect(box).to have_attributes(width: [:native], height: [:native])
    end

    it 'allows native to be a string' do
      args = { width: 'native' }
      box = Squib::Args.extract_scale_box args, deck
      expect(box).to have_attributes(width: [:native], height: [:native])
    end

    it 'allows :scale on width if height has to_f' do
      args = { width: :scale, height: 75 }
      box = Squib::Args.extract_scale_box args, deck
      expect(box).to have_attributes(width: [:scale], height: [75])
    end

    it 'allows :scale on width if height has to_f' do
      args = { width: 75, height: :scale }
      box = Squib::Args.extract_scale_box args, deck
      expect(box).to have_attributes(width: [75], height: [:scale])
    end

    it 'disallows both :scale' do
      args = { width: :scale, height: :scale }
      expect { Squib::Args.extract_scale_box args, deck }.to raise_error('if width is :scale, height must be a number')
    end

    it 'disallows non-to_f on width' do
      args = { width: :foo }
      expect { Squib::Args.extract_scale_box args, deck }.to raise_error('width must be a number, :scale, :native, or :deck')
    end

    it 'disallows non-to_f on height' do
      args = { height: :foo }
      expect { Squib::Args.extract_scale_box args, deck }.to raise_error('height must be a number, :scale, :native, or :deck')
    end

  end


end
