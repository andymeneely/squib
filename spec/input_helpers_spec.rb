require 'spec_helper'
require 'squib/input_helpers'

class DummyDeck
  include  Squib::InputHelpers
  attr_accessor :layout, :cards
end

module Squib
  def logger=(l)
    @logger = l
  end
  module_function 'logger='
end

describe Squib::InputHelpers do


  before(:each) do
    @deck = DummyDeck.new
    @deck.layout = {'blah' => {x: 25}}
    @deck.cards = %w(a b)
  end

  context '#layoutify' do
    it "should warn on the logger when the layout doesn't exist" do
      @old_logger = Squib.logger
      Squib.logger = instance_double(Logger)
      expect(Squib.logger).to receive(:warn).with("Layout entry 'foo' does not exist.")
      expect(@deck.send(:layoutify, {layout: :foo})).to eq({layout: :foo}) 
      Squib.logger = @old_logger
    end

    it "should apply the layout in a normal situation" do
      expect(@deck.send(:layoutify, {layout: :blah})).to eq({layout: :blah, x: 25}) 
    end

    it "also look up based on strings" do
      expect(@deck.send(:layoutify, {layout: 'blah'})).to eq({layout: 'blah', x: 25}) 
    end
  end

  context '#rangeify' do
    it "must be within the card size range" do
      expect{@deck.send(:rangeify, {range: 2..3})}.to raise_error(ArgumentError, '2..3 is outside of deck range of 0..1')
    end

    it "cannot be nil" do
      expect{@deck.send(:rangeify, {range: nil})}.to raise_error(RuntimeError, 'Range cannot be nil')
    end

    it "defaults to a range of all cards if :all" do
      expect(@deck.send(:rangeify, {range: :all})).to eq({range: 0..1})
    end

  end

end