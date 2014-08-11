require 'spec_helper'
require 'squib/input_helpers'

class DummyDeck
  include  Squib::InputHelpers
  attr_accessor :layout, :cards, :custom_colors
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
    @deck.custom_colors = {}
  end

  context '#layoutify' do
    it "should warn on the logger when the layout doesn't exist" do
      @old_logger = Squib.logger
      Squib.logger = instance_double(Logger)
      expect(Squib.logger).to receive(:warn).with("Layout entry 'foo' does not exist.").twice
      expect(@deck.send(:layoutify, {layout: :foo})).to eq({layout: [:foo,:foo]}) 
      Squib.logger = @old_logger
    end

    it "should apply the layout in a normal situation" do
      expect(@deck.send(:layoutify, {layout: :blah})).to \
        eq({layout: [:blah, :blah], x: 25}) 
    end

    it "also look up based on strings" do
      expect(@deck.send(:layoutify, {layout: 'blah'})).to \
        eq({layout: ['blah','blah'], x: 25}) 
    end
  end

  context '#rangeify' do
    it "must be within the card size range" do
      expect{@deck.send(:rangeify, {range: 2..3})}.to \
        raise_error(ArgumentError, '2..3 is outside of deck range of 0..1')
    end

    it "cannot be nil" do
      expect{@deck.send(:rangeify, {range: nil})}.to \
        raise_error(RuntimeError, 'Range cannot be nil')
    end

    it "defaults to a range of all cards if :all" do
      expect(@deck.send(:rangeify, {range: :all})).to eq({range: 0..1})
    end
  end

  context "#fileify" do
    it "should throw an error if the file doesn't exist" do
      expect{@deck.send(:fileify, {file: 'nonexist.txt'}, true)}.to \
        raise_error(RuntimeError,"File #{File.expand_path('nonexist.txt')} does not exist!")
    end
  end

  context "#dir" do
    it "should raise an error if the directory does not exist" do
      expect{@deck.send(:dirify, {dir: 'nonexist'}, false)}.to \
        raise_error(RuntimeError,"'nonexist' does not exist!")
    end
  end

  context "#colorify" do
    it "should parse if nillable" do
      color = @deck.send(:colorify, {color: ['#fff']}, true)[:color]
      expect(color.to_a[0].to_a).to eq([1.0, 1.0, 1.0, 1.0])
    end

    it "raises and error if the color doesn't exist" do
      expect{ @deck.send(:colorify, {color: [:nonexist]}, false) }.to \
        raise_error(ArgumentError, "unknown color name: nonexist")
    end

    it "pulls from config's custom colors" do
      @deck.custom_colors['foo'] = "#abc"
      expect(@deck.send(:colorify, {color: [:foo]}, false)[:color][0].to_s).to \
        eq('#AABBCCFF')
    end

    it "pulls from config's custom colors even when a string" do
      @deck.custom_colors['foo'] = "#abc"
      expect(@deck.send(:colorify, {color: ['foo']}, false)[:color][0].to_s).to \
        eq('#AABBCCFF')
    end
  end

end