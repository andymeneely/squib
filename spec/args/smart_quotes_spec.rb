require 'spec_helper'
require 'squib/args/smart_quotes'

describe Squib::Args::SmartQuotes do

  it 'does nothing on a non-quoted string' do
    expect(subject.quotify('nothing')).to eq('nothing')
  end

  it 'left quotes at the beginning' do
    expect(subject.quotify('"foo')).to eq("\u201Cfoo")
  end

  it 'left quotes in the middle of the string' do
    expect(subject.quotify('hello "foo')).to eq("hello \u201Cfoo")
  end

  it 'right quotes at the end of a string' do
    expect(subject.quotify('foo"')).to eq("foo\u201D")
  end

  it 'handles the entire string quoted' do
    expect(subject.quotify('"foo"')).to eq("\u201Cfoo\u201D")
  end

  it "quotes in the middle of the string" do
    expect(subject.quotify('hello "foo" world')).to eq("hello \u201Cfoo\u201D world")
  end

  it "allows custom quotes for different character sets" do
    expect(subject.quotify('hello "foo" world', %w({ }))).to eq("hello {foo} world")
  end

  it "processes dumb quotes" do
    expect(subject.process('hello "foo" world', :dumb)).to eq("hello \"foo\" world")
  end

  it "processes smart quotes" do
    expect(subject.process('hello "foo" world', :smart)).to eq("hello \u201Cfoo\u201D world")
  end

  it "processes custom quotes" do
    expect(subject.process('hello "foo" world', %w({ }))).to eq("hello {foo} world")
  end

end