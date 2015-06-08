require 'spec_helper'
require 'squib/args/box'

describe Squib::Args::Draw do
  subject(:draw) { Squib::Args::Draw.new }

  context 'unit conversion' do

    it 'converts units on stroke width' do
      args = {stroke_width: '2in'}
      draw.load!(args, expand_by: 2)
      expect(draw).to have_attributes(stroke_width: [600, 600])
    end

  end

  context 'validation' do

    it 'converts to Cairo options' do
      args = {join: 'bevel', cap: 'round'}
      draw.load!(args)
      expect(draw).to have_attributes(join: [Cairo::LINE_JOIN_BEVEL])
    end

  end

end