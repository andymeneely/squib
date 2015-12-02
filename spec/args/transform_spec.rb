require 'spec_helper'
require 'squib/args/transform'

describe Squib::Args::Box do
  subject(:trans) { Squib::Args::Transform.new }
  let(:expected_defaults) { {x: [0], y: [0], crop_width: [:native], crop_height: [:native] } }

  context 'validation' do
    it 'replaces with deck width and height' do
      args  = {crop_width: :deck, crop_height: :deck}
      deck  = OpenStruct.new(width: 123, height: 456)
      trans = Squib::Args::Transform.new(deck)
      trans.load!(args, expand_by: 1)
      expect(trans).to have_attributes(crop_width: [123], crop_height: [456])
    end

    it 'has radius override x_radius and y_radius' do
      args = {crop_corner_x_radius: 1, crop_corner_y_radius: 2, crop_corner_radius: 3}
      trans.load!(args, expand_by: 2)
      expect(trans).to have_attributes(crop_corner_x_radius: [3, 3], crop_corner_y_radius: [3, 3])
    end

  end

end