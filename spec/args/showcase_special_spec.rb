require 'spec_helper'
require 'squib/args/showcase_special'

describe Squib::Args::ShowcaseSpecial do
  subject(:showcase_special) { Squib::Args::ShowcaseSpecial.new }

  context '#face_right?' do
    it 'compares face to right' do
      opts = { face: 'LEFT ' }
      showcase_special.load! opts
      expect(showcase_special.face_right?).to be false
    end
  end

end
