require 'spec_helper'
require 'squib'

describe :build_group do

  context '#enable_build_globally' do
    before(:each) { ENV['SQUIB_BUILD'] = '' }

    it 'enables one group via ENV' do
      Squib.enable_build_globally 'foo'
      expect(ENV['SQUIB_BUILD']).to eq 'foo'
    end

    it 'enables two groups via ENV' do
      Squib.enable_build_globally 'foo'
      Squib.enable_build_globally 'bar'
      expect(ENV['SQUIB_BUILD']).to eq 'foo,bar'
    end

    it 'uniqs the groups' do
      Squib.enable_build_globally 'foo'
      Squib.enable_build_globally 'bar'
      Squib.enable_build_globally 'bar'
      expect(ENV['SQUIB_BUILD']).to eq 'foo,bar'
    end

    it 'handles symbols' do
      Squib.enable_build_globally :foo
      expect(ENV['SQUIB_BUILD']).to eq 'foo'
    end

  end

  context '#disable_build_globally' do
    before(:each) { ENV['SQUIB_BUILD'] = 'foo,bar' }

    it 'can be disabled globally via ENV' do
      Squib.disable_build_globally 'bar'
      expect(ENV['SQUIB_BUILD']).to eq 'foo'
    end

    it 'handles symbols' do
      Squib.disable_build_globally :bar
      expect(ENV['SQUIB_BUILD']).to eq 'foo'
    end
  end


end
