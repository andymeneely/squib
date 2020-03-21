require 'spec_helper'
require_relative 'docs_helper'

describe 'docs spec helper' do

  it 'gets all documented options for background' do
    options = documented_options(:Background)
    expect(options.sort).to eq(%i(color range))
  end

  it 'gets all documented options for grid.rst' do
    expected = %i(x y width height fill_color stroke_color stroke_width
      stroke_strategy join dash cap range layout)
    options = documented_options(:Grid)
    expect(options.sort).to eq(expected.sort)
  end

end
