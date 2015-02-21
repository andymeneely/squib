require 'spec_helper'
require 'squib'

describe Squib::Card do

  def expect_stroke(fill_color, stroke_color, stroke_width)
    expect(@context).to receive(:set_source_color).with(stroke_color).once
    expect(@context).to receive(:set_line_width).with(stroke_width).once
    expect(@context).to receive(:stroke).once
    expect(@context).to receive(:set_source_color).with(fill_color).once
    expect(@context).to receive(:fill).once
  end

  before(:each) do
    @deck    = double(Squib::Deck)
    @context = double(Cairo::Context)
    allow(Cairo::Context).to receive(:new).and_return(@context)
    allow(@deck).to receive(:dir).and_return('_output')
    allow(@deck).to receive(:count_format).and_return('%02d')
    allow(@deck).to receive(:prefix).and_return('card_')
  end

  context 'rect' do
    it 'make all the expected calls on a smoke test' do
      expect(@context).to receive(:save).once
      expect(@context).to receive(:rounded_rectangle).with(37, 38, 50, 100, 10, 15).twice
      expect_stroke('#fff', '#f00', 2.0)
      expect(@context).to receive(:restore).once

      card = Squib::Card.new(@deck, 100, 150)
      # rect(x, y, width, height, x_radius, y_radius,
      #      fill_color, stroke_color, stroke_width)
      card.rect(37, 38, 50, 100, 10, 15, '#fff', '#f00', 2.0)
    end
  end

  context 'circle' do
    it 'make all the expected calls on a smoke test' do
      expect(@context).to receive(:save).once
      expect(@context).to receive(:move_to).with(37, 38)
      expect(@context).to receive(:circle).with(37, 38, 100).twice
      expect_stroke('#fff', '#f00', 2.0)
      expect(@context).to receive(:restore).once

      card = Squib::Card.new(@deck, 100, 150)
      # circle(x, y, radius,
      #        fill_color, stroke_color, stroke_width)
      card.circle(37, 38, 100, '#fff', '#f00', 2.0)
    end
  end

  context 'triangle' do
    it 'make all the expected calls on a smoke test' do
      expect(@context).to receive(:save).once
      expect(@context).to receive(:triangle).with(1, 2, 3, 4, 5, 6).twice
      expect_stroke('#fff', '#f00', 2.0)
      expect(@context).to receive(:restore).once

      card = Squib::Card.new(@deck, 100, 150)
      card.triangle(1, 2, 3, 4, 5, 6, '#fff', '#f00', 2.0)
    end
  end

  context 'line' do
    it 'make all the expected calls on a smoke test' do
      expect(@context).to receive(:save).once
      expect(@context).to receive(:move_to).with(1, 2).once
      expect(@context).to receive(:line_to).with(3, 4).once
      expect(@context).to receive(:set_source_color).with('#fff').once
      expect(@context).to receive(:set_line_width).with(2.0).once
      expect(@context).to receive(:stroke).once
      expect(@context).to receive(:restore).once

      card = Squib::Card.new(@deck, 100, 150)
      card.line(1, 2, 3, 4, '#fff', 2.0)
    end
  end
end
