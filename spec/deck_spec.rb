require 'squib/deck'
include Squib

describe Deck.new do 
  it "initializes with default parameters" do
    d = Deck.new
    expect(d.width).to eq(825)
    expect(d.height).to eq(1125)
    expect(d.cards).to eq(1)
  end
end
  
