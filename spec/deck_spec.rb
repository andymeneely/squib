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
      expect(card1).to receive(:text).with('blah','Arial 36',0,0,{}).once
      expect(card2).to receive(:text).with('blah','Arial 36',0,0,{}).once
      Squib::Deck.new do  
        @cards = [card1, card2]  
        text str: 'blah'
      end
    end

    it "calls text on some cards with an integer" do
      card1 = instance_double(Squib::Card)
      card2 = instance_double(Squib::Card)
      expect(card2).to receive(:text).with('blah','Arial 36',0,0,{}).once
      Squib::Deck.new do  
        @cards = [card1, card2]  
        text range: 1, str: 'blah'
      end
    end  

    it "calls text with ranges" do
      card1 = instance_double(Squib::Card)
      card2 = instance_double(Squib::Card)
      card3 = instance_double(Squib::Card)
      expect(card1).to receive(:text).with('blah','Arial 36',0,0,{}).once
      expect(card2).to receive(:text).with('blah','Arial 36',0,0,{}).once
      Squib::Deck.new do  
        @cards = [card1, card2, card3]  
        text range: 0..1, str: 'blah'
      end
    end
  end

end#describe

