require 'spec_helper'
require 'squib'

describe Squib::Deck do
  let(:deck) { Squib::Deck.new(width: 10, height: 10) }
  it 'provides useful errors in background' do
    expect_any_instance_of(Squib::DSL::Background).to receive(:run).and_raise 'OOPSIE'

    deck.background
  end
end
