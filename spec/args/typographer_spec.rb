require 'spec_helper'
require 'squib/args/typographer'

describe Squib::Args::Typographer do
  subject(:t) { Squib::Args::Typographer.new }

  it 'does nothing on a non-quoted string' do
    expect(t.process(%(nothing))).to eq(%(nothing))
  end

  it 'left quotes at the beginning' do
    expect(t.process(%("foo))).to eq(%(“foo))
  end

  it 'left quotes in the middle of the string' do
    expect(t.process(%(hello "foo))).to eq(%(hello “foo))
  end

  it 'right quotes at the end' do
    expect(t.process(%(foo"))).to eq(%(foo”))
  end

  it 'handles the entire string quoted' do
    expect(t.process(%("foo"))).to eq(%(“foo”))
  end

  it 'quotes in the middle of the string' do
    expect(t.process(%(hello "foo" world))).to eq(%(hello “foo” world))
  end

  it 'single left quotes at the beginning' do
    expect(t.process(%('foo))).to eq(%(‘foo))
  end

  it 'single right quotes at the end' do
    expect(t.process(%(foo'))).to eq(%(foo’))
  end

  it 'single quotes in the middle' do
    expect(t.process(%(a 'foo' bar))).to eq(%(a ‘foo’ bar))
  end

  it 'handles apostraphes' do
    expect(t.process(%(can't))).to eq(%(can’t))
  end

  it 'single quotes inside double quotes' do
    expect(t.process(%("'I can't do that', he said"))).to eq(%(“‘I can’t do that’, he said”))
  end

  it 'replaces the straightforward ones' do
    expect(t.process(%(``hi...'' -- ---))).to eq(%(“hi…” – —))
  end

  it 'does nothing on lone quotes' do
    expect(t.process(%("))).to eq(%("))
    expect(t.process(%('))).to eq(%('))
  end

  it 'ignores stuff in <tags>' do
    expect(t.process(%(<span weight="bold">"can't"</span>))).to eq(%(<span weight="bold">“can’t”</span>))
  end

  context 'configured' do
    # TODO
  end
end
