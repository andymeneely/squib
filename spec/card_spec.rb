require 'spec_helper'
require 'squib/card'

describe Squib::Card do
  it 'logs fatal for unknown backend' do
    deck = OpenStruct.new(dir: '.', prefix: '', count_format: '%02d', backend: 'broken robots')

    expect(Squib::logger).to receive(:fatal).with("Back end not recognized: 'broken robots'")
    expect { Squib::Card.new(deck, 100, 100, 0) }.to raise_error SystemExit
  end
end