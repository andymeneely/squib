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

    it "applies the single-level extends multiple times" do
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

    it "applies multiple extends in a single rule" do
      d = Squib::Deck.new(layout: test_file('multi-extends-single-entry.yml')) 
      expect(d.layout).to \
        eq({'aunt' => {
              'a' => 101, 
              'b' => 102, 
              'c' => 103, 
              },
            'uncle' => {
              'x' => 104, 
              'y' => 105, 
              'b' => 106, 
              },
            'child' => {
              'extends' => ['uncle','aunt'],
              'a' => 107, # my own
              'b' => 102, # from the younger aunt
              'c' => 103, # from aunt
              'x' => 108, # my own
              'y' => 105, # from uncle
              },
            }
          )
    end

    it "applies multi-level extends" do
      d = Squib::Deck.new(layout: test_file('multi-level-extends.yml')) 
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
            'subtitle' => {
              'extends' => 'title',
              'x' => 38,
              'y' => 150, 
              'width' => 100,
              },
            }
          )
    end

    it "fails on a self-circular extends" do
      file = test_file('self-circular-extends.yml')
      expect { Squib::Deck.new(layout: file) }.to \
        raise_error(RuntimeError, "Invalid layout: circular extends with 'a'")
    end

    it "fails on a easy-circular extends" do
      file = test_file('easy-circular-extends.yml')
      expect { Squib::Deck.new(layout: file) }.to \
        raise_error(RuntimeError, "Invalid layout: circular extends with 'a'")
    end

    it "hard on a easy-circular extends" do
      file = test_file('hard-circular-extends.yml')
      expect { Squib::Deck.new(layout: file) }.to \
        raise_error(RuntimeError, "Invalid layout: circular extends with 'a'")
    end

  end

end
