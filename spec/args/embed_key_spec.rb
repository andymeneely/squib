require 'spec_helper'
require 'squib/args/embed_key'

describe Squib::Args::EmbedKey do

  context '#validate_key' do

    it 'converts to string' do
      expect(subject.validate_key(2.5)).to eq ('2.5')
    end

  end
end
