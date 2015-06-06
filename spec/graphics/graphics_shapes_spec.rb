require 'spec_helper'
require 'squib'

describe Squib::Card do

  let(:deck) { double(Squib::Deck) }
  let(:cxt)  { double(Cairo::Context) }

  def expect_stroke(cxt, fill_color, stroke_color, stroke_width)
    expect(cxt).to receive(:set_source_color).with(stroke_color).once
    expect(cxt).to receive(:set_line_width).with(stroke_width).once
    expect(cxt).to receive(:stroke).once
    expect(cxt).to receive(:set_source_color).with(fill_color).once
    expect(cxt).to receive(:fill).once
  end

  before(:each) do
    allow(Cairo::Context).to receive(:new).and_return(cxt)
    allow(deck).to receive(:dir).and_return('_output')
    allow(deck).to receive(:count_format).and_return('%02d')
    allow(deck).to receive(:prefix).and_return('card_')
    allow(deck).to receive(:antialias).and_return('subpixel')
    allow(deck).to receive(:backend).and_return('memory')
  end

  context 'rect' do
    it 'make all the expected calls on a smoke test' do
      expect(cxt).to receive(:antialias=).with('subpixel')
      expect(cxt).to receive(:save).once
      expect(cxt).to receive(:rounded_rectangle).with(37, 38, 50, 100, 10, 15).twice
      expect_stroke(cxt, '#fff', '#f00', 2.0)
      expect(cxt).to receive(:restore).once

      card = Squib::Card.new(deck, 100, 150)
      # rect(x, y, width, height, x_radius, y_radius,
      #      fill_color, stroke_color, stroke_width)
      card.rect(37, 38, 50, 100, 10, 15, '#fff', '#f00', 2.0)
    end
  end

  context 'circle' do
    it 'make all the expected calls on a smoke test' do
      expect(cxt).to receive(:antialias=).with('subpixel')
      expect(cxt).to receive(:save).once
      expect(cxt).to receive(:move_to).with(137, 38)
      expect(cxt).to receive(:circle).with(37, 38, 100).twice
      expect_stroke(cxt, '#fff', '#f00', 2.0)
      expect(cxt).to receive(:restore).once

      card = Squib::Card.new(deck, 100, 150)
      # circle(x, y, radius,
      #        fill_color, stroke_color, stroke_width)
      card.circle(37, 38, 100, '#fff', '#f00', 2.0)
    end
  end

  context 'triangle' do
    it 'make all the expected calls on a smoke test' do
      expect(cxt).to receive(:antialias=).with('subpixel')
      expect(cxt).to receive(:save).once
      expect(cxt).to receive(:triangle).with(1, 2, 3, 4, 5, 6).twice
      expect_stroke(cxt, '#fff', '#f00', 2.0)
      expect(cxt).to receive(:restore).once

      card = Squib::Card.new(deck, 100, 150)
      card.triangle(1, 2, 3, 4, 5, 6, '#fff', '#f00', 2.0)
    end
  end

  context 'line' do
    it 'make all the expected calls on a smoke test' do
      expect(cxt).to receive(:antialias=).with('subpixel')
      expect(cxt).to receive(:save).once
      expect(cxt).to receive(:move_to).with(1, 2).once
      expect(cxt).to receive(:line_to).with(3, 4).once
      expect(cxt).to receive(:set_source_color).with('#fff').once
      expect(cxt).to receive(:set_line_width).with(2.0).once
      expect(cxt).to receive(:stroke).once
      expect(cxt).to receive(:restore).once

      card = Squib::Card.new(deck, 100, 150)
      card.line(1, 2, 3, 4, '#fff', 2.0)
    end
  end
end
