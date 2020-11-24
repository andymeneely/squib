require 'spec_helper'
require 'squib/args/box'

describe Squib::Args::Box do
  let(:deck) { OpenStruct.new(width: 123, height: 456, size: 1, dpi: 300.0, cell_px: 37.5) }
  let(:expected_defaults) { { x: [0], y: [0], width: [123], height: [456] } }

  it 'intitially has no params set' do
    box = Squib::Args::Box.new
    expect(box).not_to respond_to(:x, :y, :width, :height)
  end

  it 'extracts the defaults from Box on an empty hash' do
    args = {}
    box = Squib::Args.extract_box args, deck
    expect(box).to have_attributes(expected_defaults)
  end

  it 'extracts what is specified and fills in defaults from Box' do
    args = {x: 4, width: 40}
    box = Squib::Args.extract_box args, deck
    expect(box).to have_attributes(x: [4], width: [40], y: [0], height: [456])
  end

  it 'extracts the defaults from Box on an empty hash' do
    args = { foo: :bar }
    box = Squib::Args.extract_box args, deck
    expect(box).to have_attributes(expected_defaults)
    expect(box).not_to respond_to(:foo)
  end

  context 'single expansion' do
    let(:args)      { { x: [1, 2], y: 3 } }
    let(:deck_of_2) { OpenStruct.new(width: 123, height: 456, size: 2) }
    let(:box)       { Squib::Args.extract_box args, deck_of_2 }

    it 'expands box' do
      expect(box).to have_attributes({
          x: [1, 2],
          y: [3, 3],
          width: [123, 123],
          height: [456, 456],
      })
    end

    it 'gives access to each card too' do
      expect(box[0]).to have_attributes({
        x: 1,
        y: 3,
        width: 123,
        height: 456,
        })
    end
  end

  context 'layouts' do
    let(:deck_of_2) do
      OpenStruct.new(width: 123, height: 456, size: 2,
        dpi: 300, cell_px: 37.5, layout: {
        'attack' => { 'x' => 50 },
        'defend' => { 'x' => 60 },
      })
    end

    it 'are used when not specified' do
      args = { layout: ['attack', 'defend'] }
      box = Squib::Args.extract_box args, deck_of_2
      expect(box).to have_attributes(
         x: [50, 60],  # set by layout
         y: [0, 0],    # Box default
        )
    end

    it 'handle single expansion' do
      args = { layout: 'attack' }
      box = Squib::Args.extract_box args, deck_of_2
      expect(box).to have_attributes(
         x: [50, 50],  # set by layout
         y: [0, 0],    # Box default
        )
    end

    it 'handles symbols' do
      args = { layout: :attack }
      box = Squib::Args.extract_box args, deck_of_2
      expect(box).to have_attributes(
         x: [50, 50],  # set by layout
         y: [0, 0],    # Box default
        )
    end

    it 'warns on non-existent layouts' do
      args = { layout: :heal }
      expect(Squib.logger).to receive(:warn).with('Layout "heal" does not exist in layout file - using default instead').at_least(:once)
      box = Squib::Args.extract_box args, deck_of_2
      expect(box).to have_attributes(
         x: [0, 0], # Box default
         y: [0, 0], # Box default
        )
    end
  end

  context 'unit conversion' do
    let(:deck_of_2) { OpenStruct.new(width: 123, height: 456, size: 2, dpi: 300, cell_px: 37.5) }

    it 'converts units on all args' do
      args = { x: ['1in', '2in'], y: 300, width: '1in', height: '1in' }
      box = Squib::Args.extract_box args, deck_of_2
      expect(box).to have_attributes(
        x: [300.0, 600.0],
        y: [300, 300],
        width: [300.0, 300.0],
        height: [300.0, 300.0],
      )
    end

    it 'handles cells' do
      args = {x: '1c', y: '1c', width: '1c', height: '1c'}
      box = Squib::Args.extract_box args, deck
      expect(box).to have_attributes(
        x: [37.5],
        width: [37.5],
        y: [37.5],
        height: [37.5],
      )
    end

  end

  context 'validation' do
    it 'replaces with deck width and height' do
      args = { width: :deck, height: :deck }
      box = Squib::Args.extract_box args, deck
      expect(box).to have_attributes(width: [123], height: [456])
    end

    it 'has radius override x_radius and y_radius' do
      args = { x_radius: 1, y_radius: 2, radius: 3 }
      box = Squib::Args.extract_box args, deck
      expect(box).to have_attributes(x_radius: [3], y_radius: [3])
    end

    it 'listens to middle' do
      args = { width: :middle, height: 'middle' }
      box = Squib::Args.extract_box args, deck
      expect(box).to have_attributes(width: [61.5], height: [228.0])
    end

    it 'listens to center' do
      args = { width: 'center', height: :center }
      box = Squib::Args.extract_box args, deck
      expect(box).to have_attributes(width: [61.5], height: [228.0])
    end

    it 'listens to deck/2' do
      args = { width: 'deck / 2', height: :deck }
      box = Squib::Args.extract_box args, deck
      expect(box).to have_attributes(width: [61.5], height: [456])
    end

    it 'listens to deck - 0.5in' do
      args = { x: 'deck - 0.5in'}
      box = Squib::Args.extract_box args, deck
      expect(box).to have_attributes(x: [ 123 - 150 ])
    end

  end

  context 'xywh shorthands' do

    it 'handles shorthands' do
      args = {
        x: 'middle + 1c',
        y: 'middle',
        width: 'deck - 2c',
        height: 'deck / 3'
      }
      box = Squib::Args.extract_box args, deck
      expect(box).to have_attributes(
        x: [99.0],
        y: [228.0],
        width: [48.0],
        height: [152.0]
      )
    end

  end

end
