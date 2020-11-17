require 'spec_helper'
require 'squib/args/xywh_shorthands'

describe Squib::Args::XYWHShorthands do

  let(:deck) { OpenStruct.new(width: 100, height: 200, size: 1, dpi: 300.0) }

  it 'handles middle' do
    args = {
      x: 'middle',
      y: 'middle + 1in',
      width: 'width / 2',
      height: 'height - 1in',
    }
    box = Squib::Args.extract_box args, deck
    expect(box).to have_attributes({
      x: [50.0],
      y: [400.0],
      width: [50.0],
      height: [-100.0]
    })
  end


end

