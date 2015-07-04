require 'spec_helper'
require 'squib/graphics/cairo_context_wrapper'

describe Squib::Graphics::CairoContextWrapper do
  let(:cairo) { double(Cairo::Context) }
  subject     { Squib::Graphics::CairoContextWrapper.new(cairo) }

  it 'passes on colors as normal' do
    expect(cairo).to receive(:set_source_color).with('blue')
    subject.set_source_squibcolor('blue')
  end

  it 'passes on color symbols as normal' do
    expect(cairo).to receive(:set_source_color).with(:blue)
    subject.set_source_squibcolor(:blue)
  end

  it 'passes on color hashes' do
    expect(cairo).to receive(:set_source_color)
      .with('#aabbccdd')
    subject.set_source_squibcolor('#aabbccdd')
  end

  context 'regex variations for linear gradients' do
    before(:each) do
      dbl = double(Cairo::LinearPattern)
      expect(Cairo::LinearPattern).to receive(:new).with(1, 2, 3, 4).and_return(dbl)
      expect(dbl).to receive(:add_color_stop).with(0.0, 'blue')
      expect(dbl).to receive(:add_color_stop).with(1.0, 'red')
      expect(cairo).to receive(:set_source).with(dbl)
    end

    it('handles no decimals') { subject.set_source_squibcolor('(1,2) (3,4) blue@0 red@1') }
    it('handles decimals') { subject.set_source_squibcolor('(1.0,2.0) (3.0,4.0) blue@0 red@1') }
    it('handles no whitespace') { subject.set_source_squibcolor('(1,2)(3,4)blue@0red@1') }
    it('handles whitespace') { subject.set_source_squibcolor('  (  1  ,  2  )  ( 3  ,  4  )  blue@0   red@1   ') }
  end

  context 'regex variations for radial gradients' do
    before(:each) do
      dbl = double(Cairo::RadialPattern)
      expect(Cairo::RadialPattern).to receive(:new).with(1, 2, 5, 3, 4, 6).and_return(dbl)
      expect(dbl).to receive(:add_color_stop).with(0.0, 'blue')
      expect(dbl).to receive(:add_color_stop).with(1.0, 'red')
      expect(cairo).to receive(:set_source).with(dbl)
    end

    it('handles no decimals') { subject.set_source_squibcolor('(1,2,5) (3,4,6) blue@0 red@1') }
    it('handles decimals') { subject.set_source_squibcolor('(1.0,2.0,5.0) (3.0,4.0,6.0) blue@0 red@1') }
    it('handles no whitespace') { subject.set_source_squibcolor('(1,2,5)(3,4,6)blue@0red@1') }
    it('handles whitespace') { subject.set_source_squibcolor('  (  1  ,  2  , 5 )  ( 3  ,  4 , 6 )  blue@0   red@1   ') }
  end

  context 'regex handles hash notation' do
    it 'on radial patterns' do
      dbl = double(Cairo::RadialPattern)
      expect(Cairo::RadialPattern).to receive(:new).with(1, 2, 5, 3, 4, 6).and_return(dbl)
      expect(dbl).to receive(:add_color_stop).with(0.0, '#def')
      expect(dbl).to receive(:add_color_stop).with(1.0, '#112233')
      expect(cairo).to receive(:set_source).with(dbl)
      subject.set_source_squibcolor('(1,2,5) (3,4,6) #def@0 #112233@1')
    end

    it 'on linear patterns' do
      dbl = double(Cairo::LinearPattern)
      expect(Cairo::LinearPattern).to receive(:new).with(1, 2, 3, 4).and_return(dbl)
      expect(dbl).to receive(:add_color_stop).with(0.0, '#def')
      expect(dbl).to receive(:add_color_stop).with(1.0, '#112233')
      expect(cairo).to receive(:set_source).with(dbl)
      subject.set_source_squibcolor('(1,2) (3,4) #def@0 #112233@1')
    end
  end
end
