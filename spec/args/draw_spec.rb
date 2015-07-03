require 'spec_helper'
require 'squib/args/box'

describe Squib::Args::Draw do
  let(:custom_colors) { {'foo' => 'abc'} }
  subject(:draw)      {Squib::Args::Draw.new(custom_colors)}

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
      expect(draw).to have_attributes(
        join: [Cairo::LINE_JOIN_BEVEL],
        cap: [Cairo::LINE_CAP_ROUND]
        )
    end

    it 'parses dash options' do
      args = {dash: '3 4 5'}
      draw.load!(args)
      expect(draw).to have_attributes(dash: [[3, 4, 5]])
    end

    it 'parses more complex dash options' do
      args = {dash: '30.5,  90,  5'}
      draw.load!(args)
      expect(draw).to have_attributes(dash: [[30.5, 90, 5]])
    end

    it 'does unit conversion on dash options' do
      args = {dash: '3in  4in 5in'}
      draw.load!(args)
      expect(draw).to have_attributes(dash: [[900, 1200, 1500]])
    end

    context 'custom colors' do

      it 'looks up custom colors in the config' do
        draw.load!({color: 'foo'})
        expect(draw.color).to eq ['abc']
      end

      it 'passes on through for non-custom color' do
        draw = Squib::Args::Draw.new(custom_colors)
        draw.load!({color: 'bar'})
        expect(draw.color).to eq ['bar']
      end

    end
  end
end