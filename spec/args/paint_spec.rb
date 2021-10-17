# typed: false
require 'spec_helper'
require 'squib/args/paint'

describe Squib::Args::Draw do
  let(:custom_colors) { { 'foo' => 'abc' } }
  subject(:paint) {Squib::Args::Paint.new(custom_colors)}

  context 'alpha' do

    it 'can be a float' do
      args = { alpha: 0.6 }
      paint.load!(args)
      expect(paint.alpha).to eq [0.6]
    end

    it 'raises exception when not a float' do
      args = { alpha: /6/ }
      expect { paint.load!(args) }.to raise_error('alpha must respond to to_f')
    end

  end
end
