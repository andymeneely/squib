require 'spec_helper'
require 'squib'

describe Squib::Deck, '#save_pdf' do

  context 'typical inputs' do
    let(:cxt)    { double(Cairo::Context) }
    let(:target) { double(Cairo::PDFSurface) }

    def expect_card_place(x, y)
      expect(cxt).to receive(:translate).with(x, y).once
      expect(cxt).to receive(:rectangle).once
      expect(cxt).to receive(:clip).once
      expect(cxt).to receive(:set_source)  # place the card
                      .with(instance_of(Cairo::ImageSurface), 0, 0).once
      expect(cxt).to receive(:paint).once  # paint placed card
      expect(cxt).to receive(:translate).with(-x, -y).once
      expect(cxt).to receive(:reset_clip).once
    end

    before(:each) do
      allow(Cairo::PDFSurface).to receive(:new).and_return(nil) # don't create the file
      allow(Cairo::Context).to    receive(:new).and_return(cxt)
      allow(cxt).to receive(:antialias=)
    end

    it 'make all the expected calls on a smoke test' do
      num_cards = 9
      deck = Squib::Deck.new(cards: 9, width: 825, height: 1125)
      expect(Squib.logger).to receive(:debug).at_least(:once)
      expect(Squib.logger).to receive(:warn).exactly(:once) # warn about making the dir
      expect(Dir).to receive(:mkdir) {} # don't actually make the dir
      expect(cxt).to receive(:scale).with(0.24, 0.24)

      expect_card_place(75, 75)
      expect_card_place(831, 75)
      expect_card_place(1587, 75)
      expect_card_place(2343, 75)
      expect_card_place(75, 1131)
      expect_card_place(831, 1131)
      expect_card_place(1587, 1131)
      expect_card_place(2343, 1131)
      expect(cxt).to receive(:show_page).once
      expect_card_place(75, 75)
      expect(cxt).to receive(:target).and_return(target)
      expect(target).to receive(:finish).once

      args = { file: 'foo.pdf', dir: '_out', crop_marks: false,
               margin: 75, gap: 5, trim: 37 }
      deck.save_pdf(args)
    end

    it 'only does the three cards on a limited range' do
      num_cards = 9
      args = { range: 2..4, file: 'foo.pdf', dir: '_out', margin: 75, gap: 5, trim: 37 }
      deck = Squib::Deck.new(cards: num_cards, width: 825, height: 1125)
      expect(Squib.logger).to receive(:debug).at_least(:once)
      expect(Squib.logger).to receive(:warn).exactly(:once) # warn about making the dir
      expect(Dir).to receive(:mkdir) {} # don't actually make the dir
      expect(cxt).to receive(:scale).with(0.24, 0.24)

      expect_card_place(75, 75)
      expect_card_place(831, 75)
      expect_card_place(1587, 75)

      expect(cxt).to receive(:target).and_return(target)
      expect(target).to receive(:finish).once

      deck.save_pdf(args)
    end

  end

end
