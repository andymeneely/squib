# typed: false
require 'spec_helper'

describe Squib::DSL do
  let(:deck) { Squib::Deck.new }

  Squib::DSL.constants.each do |m|
    it "method #{m} calls warn_if_unexpected" do
      method_obj = Squib::DSL.const_get(m).new(deck, m)
      expect(method_obj).to receive(:warn_if_unexpected).and_throw(:warned)
      catch :warned do
        method_obj.run({})
      end
    end

    it "method #{m} has dsl_method and deck defined" do
      method_obj = Squib::DSL.const_get(m).new(deck, m)
      expect(method_obj).to have_attributes({deck: deck, dsl_method: m})
    end
  end

end
