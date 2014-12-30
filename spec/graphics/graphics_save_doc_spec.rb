require 'spec_helper'
require 'squib'

describe Squib::Deck, '#save_pdf' do

  def expect_card_place(x, y)
    expect(@context).to receive(:set_source)
      .with(instance_of(Cairo::ImageSurface), -37, -37)
      .once                                   # trim the card
    expect(@context).to receive(:paint).once  # paint trimmed card
    expect(@context).to receive(:set_source)  # place the card
      .with(instance_of(Cairo::ImageSurface), x, y).once
    expect(@context).to receive(:paint).once  # paint placed card
  end

  context 'typical inputs' do

    before(:each) do
      @context = double(Cairo::Context)
      allow(Cairo::PDFSurface).to receive(:new).and_return(nil) #don't create the file
    end

    it 'make all the expected calls on a smoke test' do
      num_cards = 9
      args = { file: 'foo.pdf', dir: '_out', margin: 75, gap: 5, trim: 37 }
      deck = Squib::Deck.new(cards: num_cards, width: 825, height: 1125)
      mock_squib_logger(@old_logger) do
        expect(Squib.logger).to receive(:debug).at_least(:once)
        expect(Cairo::Context).to receive(:new).and_return(@context).exactly(num_cards + 1).times
        expect(deck).to receive(:dirify) { |arg| arg } #don't create the dir

        expect_card_place(75, 75)
        expect_card_place(831, 75)
        expect_card_place(1587, 75)
        expect_card_place(2343, 75)
        expect_card_place(75, 1131)
        expect_card_place(831, 1131)
        expect_card_place(1587, 1131)
        expect_card_place(2343, 1131)
        expect(@context).to receive(:show_page).once
        expect_card_place(75, 75)

        deck.save_pdf(args)
      end
    end

    it 'only does the three cards on a limited range' do
      num_cards = 9
      args = { range: 2..4, file: 'foo.pdf', dir: '_out', margin: 75, gap: 5, trim: 37 }
      deck = Squib::Deck.new(cards: num_cards, width: 825, height: 1125)
      mock_squib_logger(@old_logger) do
        expect(Squib.logger).to receive(:debug).at_least(:once)
        expect(Cairo::Context).to receive(:new).and_return(@context).exactly(4).times
        expect(deck).to receive(:dirify) { |arg| arg }  #don't create the dir

        expect_card_place(75, 75)
        expect_card_place(831, 75)
        expect_card_place(1587, 75)

        deck.save_pdf(args)
      end
    end

  end

end
