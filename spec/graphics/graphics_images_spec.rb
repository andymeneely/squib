require 'spec_helper'
require 'squib'

describe Squib::Card do

  let(:deck)    { double(Squib::Deck) }
  let(:context) { double(Cairo::Context) }
  let(:svg)     { double(RSVG::Handle) }
  let(:png)     { double(Cairo::ImageSurface) }

  before(:each) do
      allow(Cairo::Context).to receive(:new).and_return(context)
      allow(Cairo::ImageSurface).to receive(:from_png).and_return(png)
      allow(Cairo::ImageSurface).to receive(:new).and_return(png)
      allow(RSVG::Handle).to receive(:new_from_file).and_return(svg)
      allow(deck).to receive(:dir).and_return('_output')
      allow(deck).to receive(:count_format).and_return('%02d')
      allow(deck).to receive(:prefix).and_return('card_')
      allow(deck).to receive(:antialias).and_return('subpixel')
      allow(deck).to receive(:backend).and_return('memory')
  end

  context '#png' do
    it 'makes all the expected calls on a smoke test' do
      expect(context).to receive(:antialias=).with('subpixel')
      expect(context).to receive(:save).once
      expect(context).to receive(:translate).with(-37, -38).once
      expect(context).to receive(:rotate).with(0.0).once
      expect(context).to receive(:translate).with(37, 38).once
      expect(context).to receive(:set_source).with(png, 37, 38).once
      expect(context).to receive(:paint).with(0.9).once
      expect(context).to receive(:restore).once

      card = Squib::Card.new(deck, 100, 150)
      # png(file, x, y, alpha, blend, angle)
      card.png('foo.png', 37, 38, :native, :native, 0.9, :none, 0.0, nil)
    end

    it 'sets blend when needed' do
      context.as_null_object
      expect(context).to receive(:operator=).with(:overlay).once

      card = Squib::Card.new(deck, 100, 150)
      card.png('foo.png', 37, 38, :native, :native, 0.9, :overlay, 0.0, nil)
    end
  end

  context '#svg' do
    it 'makes all the expected calls on a smoke test' do
      expect(svg).to receive(:width).and_return(100).twice
      expect(svg).to receive(:height).and_return(100).twice
      expect(context).to receive(:antialias=).with('subpixel').once
      expect(context).to receive(:save).once
      expect(context).to receive(:rotate).with(0.0).once
      expect(context).to receive(:translate).with(37, 38).once
      expect(context).to receive(:scale).with(1.0, 1.0).once
      expect(context).to receive(:render_rsvg_handle).with(svg, 'id').once
      expect(context).to receive(:restore).once

      card = Squib::Card.new(deck, 100, 150)
      # svg(file, id, x, y, width, height, alpha, blend, angle)
      card.svg('foo.png', 'id', 37, 38, :native, :native, 0.9, :none, 0.0, nil)
    end

    it 'sets blend when needed' do
      context.as_null_object
      svg.as_null_object
      expect(context).to receive(:operator=).with(:overlay).once

      card = Squib::Card.new(deck, 100, 150)
      card.svg('foo.png', nil, 37, 38, :native, :native, 0.9, :overlay, 0.0, nil)
    end

    it 'sets width & height when needed' do
      context.as_null_object
      expect(svg).to receive(:width).and_return(100).once
      expect(svg).to receive(:height).and_return(100).once
      expect(context).to receive(:scale).with(2.0, 3.0).once

      card = Squib::Card.new(deck, 100, 150)
      card.svg('foo.png', nil, 37, 38, 200, 300, 0.9, :none, 0.0, nil)
    end
  end

end
