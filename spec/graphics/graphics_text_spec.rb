require 'spec_helper'
require 'squib'

describe Squib::Card, '#text' do

  context 'typical inputs' do
    before(:each) do
      @deck    = double(Squib::Deck)
      @context = double(Cairo::Context)
      @layout  = double(Pango::Layout)
      allow(Cairo::Context).to receive(:new).and_return(@context)
    end

    it 'make all the expected calls on a smoke test' do
      mock_squib_logger(@old_logger) do
        expect(Squib.logger).to receive(:debug).once
        expect(@context).to receive(:save).once
        expect(@context).to receive(:set_source_color).once
        expect(@context).to receive(:move_to).with(10, 15).once
        expect(@context).to receive(:translate).with(-10, -15).once
        expect(@context).to receive(:rotate).with(0.0).once
        expect(@context).to receive(:translate).with(10, 15).once
        expect(@context).to receive(:create_pango_layout).once.and_return(@layout)
        expect(@layout).to receive(:font_description=).with(Pango::FontDescription.new('Sans 12')).once
        expect(@layout).to receive(:text=).with('foo').once
        expect(@layout).to receive(:width=).with(20 * Pango::SCALE).once
        expect(@layout).to receive(:height=).with(25 * Pango::SCALE).once
        expect(@layout).to receive(:ellipsize=).with(Pango::Layout::ELLIPSIZE_NONE).once
        expect(@layout).to receive(:alignment=).with(Pango::Layout::ALIGN_LEFT).once
        expect(@layout).to receive(:justify=).with(false).once
        expect(@layout).to receive(:spacing=).with(1.0 * Pango::SCALE).once
        expect(@context).to receive(:update_pango_layout).once
        expect(@layout).to receive(:height).once.and_return(25)
        expect(@layout).to receive(:extents).once.and_return([0,0])
        expect(@context).to receive(:update_pango_layout).once
        expect(@context).to receive(:show_pango_layout).once
        expect(@context).to receive(:restore).once

        card = Squib::Card.new(@deck, 100, 150)
        # text(str, font, font_size, color,
        #      x, y, width, height,
        #      markup, justify, wrap, ellipsize,
        #      spacing, align, valign, hint, angle)
        card.text('foo', 'Sans 12', nil, '#abc',
                  10, 15, 20, 25,
                  nil, false, false, false,
                  1.0, :left, :top, nil, 0.0)
      end
    end
  end

  context 'convenience lookups' do
    before(:each) do
      @deck    = double(Squib::Deck)
      @context = double(Cairo::Context).as_null_object
      @layout  = double(Pango::Layout).as_null_object
      @extents = double("extents")
      allow(Cairo::Context).to receive(:new).and_return(@context)
      expect(@context).to receive(:create_pango_layout).once.and_return(@layout)
    end

    it 'aligns right with strings' do
      card = Squib::Card.new(@deck, 100, 150)
      expect(@layout).to receive(:alignment=).with(Pango::Layout::ALIGN_RIGHT).once
      card.text('foo', 'Sans 12', nil, '#abc',
                10, 15, 20, 50,
                nil, false, false, false,
                1.0, 'right', :top, nil, 0.0)
    end

    it 'aligns center with strings' do
      card = Squib::Card.new(@deck, 100, 150)
      expect(@layout).to receive(:alignment=).with(Pango::Layout::ALIGN_CENTER).once
      card.text('foo', 'Sans 12', nil, '#abc',
                10, 15, 20, 50,
                nil, false, false, false,
                1.0, 'center', :top, nil, 0.0)
    end

    it 'sets wrap to char with string char' do
      card = Squib::Card.new(@deck, 100, 150)
      expect(@layout).to receive(:wrap=).with(Pango::Layout::WRAP_CHAR).once
      card.text('foo', 'Sans 12', nil, '#abc',
                10, 15, 20, 50,
                nil, false, 'char', false,
                1.0, :left, :top, nil, 0.0)
    end

    it 'sets wrap to word with word string' do
      card = Squib::Card.new(@deck, 100, 150)
      expect(@layout).to receive(:wrap=).with(Pango::Layout::WRAP_WORD).once
      card.text('foo', 'Sans 12', nil, '#abc',
                10, 15, 20, 50,
                nil, false, 'word', false,
                1.0, :left, :top, nil, 0.0)
    end

    it 'sets wrap to word_char with symbol word_char' do
      card = Squib::Card.new(@deck, 100, 150)
      expect(@layout).to receive(:wrap=).with(Pango::Layout::WRAP_WORD_CHAR).once
      card.text('foo', 'Sans 12', nil, '#abc',
                10, 15, 20, 50,
                nil, false, :word_char, false,
                1.0, :left, :top, nil, 0.0)
    end

    it 'sets wrap to word_char with true' do
      card = Squib::Card.new(@deck, 100, 150)
      expect(@layout).to receive(:wrap=).with(Pango::Layout::WRAP_WORD_CHAR).once
      card.text('foo', 'Sans 12', nil, '#abc',
                10, 15, 20, 50,
                nil, false, true, false,
                1.0, :left, :top, nil, 0.0)
    end

    it 'sets ellipsize to start properly' do
      card = Squib::Card.new(@deck, 100, 150)
      expect(@layout).to receive(:ellipsize=).with(Pango::Layout::ELLIPSIZE_START).once
      card.text('foo', 'Sans 12', nil, '#abc',
                10, 15, 20, 50,
                nil, false, true, :start,
                1.0, :left, :top, nil, 0.0)
    end

    it 'sets ellipsize to middle properly' do
      card = Squib::Card.new(@deck, 100, 150)
      expect(@layout).to receive(:ellipsize=).with(Pango::Layout::ELLIPSIZE_MIDDLE).once
      card.text('foo', 'Sans 12', nil, '#abc',
                10, 15, 20, 50,
                nil, false, true, 'middle',
                1.0, :left, :top, nil, 0.0)
    end

  end
end
