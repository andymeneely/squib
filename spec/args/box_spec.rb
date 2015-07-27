require 'spec_helper'
require 'squib/args/box'

describe Squib::Args::Box do
  subject(:box) { Squib::Args::Box.new }
  let(:expected_defaults) { {x: [0], y: [0], width: [:deck], height: [:deck] } }

  it 'intitially has no params set' do
    expect(box).not_to respond_to(:x, :y, :width, :height)
  end

  it 'extracts the defaults from Box on an empty hash' do
    box.load!({})
    expect(box).to have_attributes(expected_defaults)
  end

  it 'extracts what is specified and fills in defaults from Box' do
    box.load!(x: 4, width: 40)
    expect(box).to have_attributes(x: [4], width: [40], y: [0], height: [:deck])
  end

  it 'extracts the defaults from Box on an empty hash' do
    box.load!({foo: :bar})
    expect(box).to have_attributes(expected_defaults)
    expect(box).not_to respond_to(:foo)
  end

  context 'single expansion' do
    let(:args)    { {x: [1, 2], y: 3} }
    before(:each) { box.load!(args, expand_by: 2) }
    it 'expands box' do
      expect(box).to have_attributes({
          x: [1, 2],
          y: [3, 3],
          height: [:deck, :deck],
          width: [:deck, :deck]
      })
    end

    it 'gives access to each card too' do
      expect(box[0]).to have_attributes({
        x: 1,
        y: 3,
        height: :deck,
        width: :deck
        })
    end
  end

  context 'layouts' do
    let(:layout) do
      { 'attack' => { 'x' => 50 },
        'defend' => { 'x' => 60 } }
    end

    it 'are used when not specified' do
      args = { layout: ['attack', 'defend'] }
      box.load!(args, expand_by: 2, layout: layout)
      expect(box).to have_attributes(
         x: [50, 60],  # set by layout
         y: [0, 0],    # Box default
        )
    end

    it 'handle single expansion' do
      args = { layout: 'attack' }
      box.load!(args, expand_by: 2, layout: layout)
      expect(box).to have_attributes(
         x: [50, 50],  # set by layout
         y: [0, 0],    # Box default
        )
    end

    it 'handles symbols' do
      args = { layout: :attack }
      box.load!(args, expand_by: 2, layout: layout)
      expect(box).to have_attributes(
         x: [50, 50],  # set by layout
         y: [0, 0],    # Box default
        )
    end

    it 'warns on non-existent layouts' do
      args = { layout: :heal}
      expect(Squib.logger).to receive(:warn).with('Layout "heal" does not exist in layout file - using default instead').at_least(:once)
      box.load!(args, expand_by: 2, layout: layout)
      expect(box).to have_attributes(
         x: [0, 0], # Box default
         y: [0, 0], # Box default
        )
    end
  end

  context 'unit conversion' do

    it 'converts units on all args' do
      args = {x: ['1in', '2in'], y: 300, width: '1in', height: '1in'}
      box.load!(args, expand_by: 2)
      expect(box).to have_attributes(
        x: [300, 600],
        y: [300, 300],
        width: [300, 300],
        height: [300, 300],
      )
    end

  end

  context 'validation' do
    it 'replaces with deck width and height' do
      args = {width: :deck, height: :deck}
      deck = OpenStruct.new(width: 123, height: 456)
      box = Squib::Args::Box.new(deck)
      box.load!(args, expand_by: 1)
      expect(box).to have_attributes(width: [123], height: [456])
    end

    it 'has radius override x_radius and y_radius' do
      args = {x_radius: 1, y_radius: 2, radius: 3}
      box.load!(args, expand_by: 2)
      expect(box).to have_attributes(x_radius: [3, 3], y_radius: [3, 3])
    end

  end


end
