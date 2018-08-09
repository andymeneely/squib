require 'spec_helper'
require 'squib/graphics/image'

describe Squib do
  context :open_png do

    it 'opens a real image file' do
      file = image_file('a.png')
      expect(Squib.open_png(file)).to respond_to(:format) # loaded?
    end

    it 'fails on a non-PNG file' do
      file = image_file('not_a_png.txt')
      expect { Squib.open_png(file) }.
        to raise_error(ArgumentError, /is not a PNG file/)

    end

  end
end
