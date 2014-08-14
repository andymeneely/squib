require 'spec_helper'
require 'squib/deck'

describe Squib::Deck do   

  it "initializes with default parameters" do
    d = Squib::Deck.new 
    expect(d.width).to eq(825)
    expect(d.height).to eq(1125)
    expect(d.cards.size).to eq(1)
  end

  context "in dealing with ranges" do
    it "calls text on all cards by default" do
      card1 = instance_double(Squib::Card)
      card2 = instance_double(Squib::Card) 
      expect(card1).to receive(:text).once
      expect(card2).to receive(:text).once
      Squib::Deck.new do  
        @cards = [card1, card2]  
        text str: 'blah'
      end
    end

    it "calls text on some cards with an integer" do
      card1 = instance_double(Squib::Card)
      card2 = instance_double(Squib::Card)
      expect(card2).to receive(:text).once
      Squib::Deck.new do  
        @cards = [card1, card2]  
        text range: 1, str: 'blah'
      end
    end  

    it "calls text with ranges" do
      card1 = instance_double(Squib::Card)
      card2 = instance_double(Squib::Card)
      card3 = instance_double(Squib::Card)
      expect(card1).to receive(:text).once
      expect(card2).to receive(:text).once
      Squib::Deck.new do  
        @cards = [card1, card2, card3]  
        text range: 0..1, str: 'blah'
      end
    end
  end

  context "#load_layout" do

    it "loads a normal layout with no extends" do
      d = Squib::Deck.new(layout: test_file('no-extends.yml')) 
      expect(d.layout).to \
        eq({'frame' => {
              'x' => 38, 
              'valign' => :middle,
              'str' => "blah",
              'font' => "Mr. Font",
              }
            }
          )
    end

    it "loads with a single extends" do
      d = Squib::Deck.new(layout: test_file('single-extends.yml')) 
      expect(d.layout).to \
        eq({'frame' => {
              'x' => 38, 
              'y' => 38, 
              },
            'title' => {
              'extends' => 'frame',
              'x' => 38, 
              'y' => 50, 
              'width' => 100,
              }
            }
          )
    end

    it "applies the extends regardless of order" do
      d = Squib::Deck.new(layout: test_file('pre-extends.yml')) 
      expect(d.layout).to \
        eq({'frame' => {
              'x' => 38, 
              'y' => 38, 
              },
            'title' => {
              'extends' => 'frame',
              'x' => 38, 
              'y' => 50, 
              'width' => 100,
              }
            }
          )
    end

    it "applies the single-level extends multiple timess" do
      d = Squib::Deck.new(layout: test_file('single-level-multi-extends.yml')) 
      expect(d.layout).to \
        eq({'frame' => {
              'x' => 38, 
              'y' => 38, 
              },
            'title' => {
              'extends' => 'frame',
              'x' => 38, 
              'y' => 50, 
              'width' => 100,
              },
            'title2' => {
              'extends' => 'frame',
              'x' => 75, 
              'y' => 150, 
              'width' => 150,
              },
            }
          )
    end

    


  end

end
