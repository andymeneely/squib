require 'spec_helper'
require 'squib/args/unit_conversion'

describe Squib::Args::UnitConversion do

  it 'does nothing on just numbers'  do
    expect(subject.parse(20)).to eq(20)
  end

  it 'strips trailing whitespace' do
    expect(subject.parse('1in ')).to eq(300)
  end

  it 'is ok w/internal whitesapce' do
    expect(subject.parse('1 in')).to eq(300)
  end

  it 'does cm'                      do
    expect(subject.parse('1cm')).to eq(118.1102361)
  end

end