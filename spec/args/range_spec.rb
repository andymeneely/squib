require 'spec_helper'
require 'squib/args/card_range'

describe Squib::Args::CardRange do

  it 'must be within the card size range' do
    expect {Squib::Args::CardRange.new(2..3, deck_size: 2)}
      .to raise_error(ArgumentError, '2..3 is outside of deck range of 0..1')
  end

  it 'defaults to range of all cards if :all' do
    range = Squib::Args::CardRange.new(:all, deck_size: 5)
    expect(range.to_a).to eq([0, 1, 2, 3, 4])
  end

  it 'creates a range of cards for singleton' do
    range = Squib::Args::CardRange.new(3, deck_size: 5)
    expect(range.to_a).to eq([3])
  end

  it 'lets arrays pass through unchanged' do
    range = Squib::Args::CardRange.new([0, 2], deck_size: 5)
    expect(range.to_a).to eq([0, 2])
  end

  it 'raises an error on everything else' do
    expect { Squib::Args::CardRange.new(:foo, deck_size: 5) }
      .to raise_error(ArgumentError, 'foo must be Enumerable (i.e. respond_to :each).')
  end

  it 'allows anything with :to_i' do
    range = Squib::Args::CardRange.new(0.9, deck_size: 5)
    expect(range.to_a).to eq([0])
  end

  it 'allows [] as an empty range' do
    range = Squib::Args::CardRange.new([], deck_size: 5)
    expect(range.to_a).to eq([])
  end

end