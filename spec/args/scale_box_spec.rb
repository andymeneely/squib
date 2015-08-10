require 'spec_helper'
require 'squib/args/scale_box'

describe Squib::Args::ScaleBox do
  subject(:box) { Squib::Args::ScaleBox.new({}) }

  context 'unit conversion' do
    it 'converts units on all args' do
      args = {x: ['1in', '2in'], y: 300, width: '1in', height: '1in'}
      box.load!(args, expand_by: 2)
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
      args = {width: :deck, height: :deck}
      deck = OpenStruct.new(width: 123, height: 456)
      box = Squib::Args::Box.new(deck)
      box.load!(args, expand_by: 1)
      expect(box).to have_attributes(width: [123], height: [456])
    end

    it 'allows :native' do
      args = {width: :native, height: :native}
      box.load!(args, expand_by: 1)
      expect(box).to have_attributes(width: [:native], height: [:native])
    end

    it 'allows native to be a string' do
      args = {width: 'native'}
      box.load!(args, expand_by: 1)
      expect(box).to have_attributes(width: [:native], height: [:native])
    end

    it 'allows :scale on width if height has to_f' do
      args = {width: :scale, height: 75}
      box.load!(args, expand_by: 1)
      expect(box).to have_attributes(width: [:scale], height: [75])
    end

    it 'allows :scale on width if height has to_f' do
      args = {width: 75, height: :scale}
      box.load!(args, expand_by: 1)
      expect(box).to have_attributes(width: [75], height: [:scale])
    end

    it 'disallows both :scale' do
      args = {width: :scale, height: :scale}
      expect { box.load!(args, expand_by: 1) }.to raise_error('if width is :scale, height must be a number')
    end

    it 'disallows non-to_f on width' do
      args = {width: :foo}
      expect { box.load!(args, expand_by: 1) }.to raise_error('width must be a number, :scale, :native, or :deck')
    end

    it 'disallows non-to_f on height' do
      args = {height: :foo}
      expect { box.load!(args, expand_by: 1) }.to raise_error('height must be a number, :scale, :native, or :deck')
    end

  end


end
