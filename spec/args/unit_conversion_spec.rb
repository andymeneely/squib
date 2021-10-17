# typed: false
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

  it 'does pt' do
    expect(subject.parse('1pt')).to eq(4.166666666666667)
    expect(subject.parse('1pt  ')).to eq(4.166666666666667)
  end

  it 'does cm' do
    expect(subject.parse('1cm')).to eq(118.1102361)
    expect(subject.parse('1cm  ')).to eq(118.1102361)
  end

  it 'does mm' do
    expect(subject.parse('1mm')).to eq(11.81102361)
    expect(subject.parse('1mm  ')).to eq(11.81102361)
  end

  it 'does deg' do
    expect(subject.parse('30deg')).to be_within(0.0001).of(0.523599)
  end

  it 'does cells' do
    expect(subject.parse('1c')).to eq(37.5)
    expect(subject.parse('1cell')).to eq(37.5)
    expect(subject.parse('1cells')).to eq(37.5)
    expect(subject.parse('1 cells')).to eq(37.5)
    expect(subject.parse('1 cells ')).to eq(37.5)
    expect(subject.parse('2c')).to eq(75)
    expect(subject.parse('  0.5c')).to eq(18.75)
    expect(subject.parse(' -0.5 c  ')).to eq(-18.75)
  end

  context 'when configured' do
    it 'does mm @ dpi=100' do
      expect(subject.parse('3.175mm', 100)).to be_within(0.001).of(12.5)
    end

    it 'does cell @ cell_px=75' do
      expect(subject.parse('1c', 100, 75)).to be_within(0.001).of(75)
    end
  end

end
