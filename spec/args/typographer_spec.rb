require 'spec_helper'
require 'squib/args/typographer'

describe Squib::Args::Typographer do
  subject(:t) { Squib::Args::Typographer.new }

  it 'does nothing on a non-quoted string' do
    expect(t.process(%{nothing})).to eq(%{nothing})
  end

  it 'left quotes at the beginning' do
    expect(t.process(%{"foo})).to eq(%{\u201Cfoo})
  end

  it 'left quotes in the middle of the string' do
    expect(t.process(%{hello "foo})).to eq(%{hello \u201Cfoo})
  end

  it 'right quotes at the end' do
    expect(t.process(%{foo"})).to eq(%{foo\u201D})
  end

  it 'handles the entire string quoted' do
    expect(t.process(%{"foo"})).to eq(%{\u201Cfoo\u201D})
  end

  it 'quotes in the middle of the string' do
    expect(t.process(%{hello "foo" world})).to eq(%{hello \u201Cfoo\u201D world})
  end

  it 'single left quotes at the beginning' do
    expect(t.process(%{'foo})).to eq(%{\u2018foo})
  end

  it 'single right quotes at the end' do
    expect(t.process(%{foo'})).to eq(%{foo\u2019})
  end

  it 'single quotes in the middle' do
    expect(t.process(%{a 'foo' bar})).to eq(%{a \u2018foo\u2019 bar})
  end

  it 'handles apostraphes' do
    expect(t.process(%{can't})).to eq(%{can\u2019t})
  end

it 'single quotes inside double quotes' do
    expect(t.process(%{"'I can't do that', he said"})).to eq(%{\u201C\u2018I can\u2019t do that\u2019, he said\u201D})
  end

  it 'replaces the straightforward ones' do
    expect(t.process(%{``hi...'' -- ---})).to eq(%{\u201Chi\u2026\u201D \u2013 \u2014})
  end

  it 'does nothing on lone quotes' do
    expect(t.process(%{"})).to eq(%{"})
    expect(t.process(%{'})).to eq(%{'})
  end

  it 'ignores stuff in <tags>' do
    expect(t.process(%{<span weight="bold">"can't"</span>})).to eq(%{<span weight="bold">\u201Ccan\u2019t\u201D</span>})
  end


  context 'configured' do
    # TODO
  end



end