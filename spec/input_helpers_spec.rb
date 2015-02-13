require 'spec_helper'
require 'squib'
require 'squib/input_helpers'

class DummyDeck
  include  Squib::InputHelpers
  attr_accessor :layout, :cards, :custom_colors, :width, :height, :dpi
end

describe Squib::InputHelpers do

  before(:each) do
    @deck = DummyDeck.new
    @deck.layout = {
      'blah' => {x: 25},
      'apples' => {x: 35},
      'oranges' => {y: 45},
    }
    @deck.cards = %w(a b)
    @deck.custom_colors = {}
    @deck.width = 100
    @deck.height = 200
    @deck.dpi = 300
  end

  context '#layoutify' do
    it 'warns on the logger when the layout does not exist' do
      expect(Squib.logger).to receive(:warn).with("Layout entry 'foo' does not exist.").twice
      expect(Squib.logger).to receive(:debug)
      expect(@deck.send(:layoutify, {layout: :foo})).to eq({layout: [:foo,:foo]})
    end

    it 'applies the layout in a normal situation' do
      expect(@deck.send(:layoutify, {layout: :blah})).to \
        eq({layout: [:blah, :blah], x: [25, 25]})
    end

    it 'applies two different layouts for two different situations' do
      expect(@deck.send(:layoutify, {layout: ['blah', 'apples']})).to \
        eq({layout: ['blah','apples'], x: [25, 35]})
    end

    it 'still has nils when not applied two different layouts differ in structure' do
      expect(@deck.send(:layoutify, {layout: ['apples', 'oranges']})).to \
        eq({layout: ['apples','oranges'], x: [35], y: [nil, 45]})
      #...this might behavior that is hard to debug for users. Trying to come up with a warning or something...
    end

    it 'also looks up based on strings' do
      expect(@deck.send(:layoutify, {layout: 'blah'})).to \
        eq({layout: ['blah','blah'], x: [25, 25]})
    end

  end

  context '#rangeify' do
    it 'must be within the card size range' do
      expect{@deck.send(:rangeify, {range: 2..3})}.to \
        raise_error(ArgumentError, '2..3 is outside of deck range of 0..1')
    end

    it 'cannot be nil' do
      expect{@deck.send(:rangeify, {range: nil})}.to \
        raise_error(RuntimeError, 'Range cannot be nil')
    end

    it 'defaults to a range of all cards if :all' do
      expect(@deck.send(:rangeify, {range: :all})).to eq({range: 0..1})
    end
  end

  context '#fileify' do
    it 'should throw an error if the file does not exist' do
      expect{@deck.send(:fileify, {file: 'nonexist.txt'}, true)}.to \
        raise_error(RuntimeError,"File #{File.expand_path('nonexist.txt')} does not exist!")
    end
  end

  context '#dirify' do
    it 'should raise an error if the directory does not exist' do
      expect{@deck.send(:dirify, {dir: 'nonexist'}, :dir, false)}.to \
        raise_error(RuntimeError,"'nonexist' does not exist!")
    end

    it 'should warn and make a directory creation is allowed' do
      opts = {dir: 'tocreate'}
      Dir.chdir(output_dir) do
        FileUtils.rm_rf('tocreate', secure: true)
        expect(Squib.logger).to receive(:warn).with("Dir 'tocreate' does not exist, creating it.").once
        expect(@deck.send(:dirify, opts, :dir, true)).to eq(opts)
        expect(Dir.exists? 'tocreate').to be true
      end
    end

  end

  context '#colorify' do
    it 'should pass through if nillable' do
      color = @deck.send(:colorify, {color: ['#fff']}, true)[:color]
      expect(color).to eq(['#fff'])
    end

    it 'pulls from custom colors in the config' do
      @deck.custom_colors['foo'] = '#abc'
      expect(@deck.send(:colorify, {color: [:foo]}, false)[:color][0].to_s).to \
        eq('#abc')
    end

    it 'pulls custom colors even when a string' do
      @deck.custom_colors['foo'] = '#abc'
      expect(@deck.send(:colorify, {color: ['foo']}, false)[:color][0].to_s).to \
        eq('#abc')
    end
  end

  context '#rotateify' do
    it 'computes a clockwise rotate properly' do
      opts = @deck.send(:rotateify, {rotate: :clockwise})
      expect(opts).to eq({ :angle => 0.5 * Math::PI,
                           :rotate => :clockwise
                         })
    end

    it 'computes a counter-clockwise rotate properly' do
      opts = @deck.send(:rotateify, {rotate: :counterclockwise})
      expect(opts).to eq({ :angle => 1.5 * Math::PI,
                           :rotate => :counterclockwise
                         })
    end
  end

  context '#convert_units' do
    it 'does not touch arrays integers' do
      args = {x: [156]}
      needed_params = [:x]
      opts = @deck.send(:convert_units, args, needed_params)
      expect(opts).to eq({ :x => [156] })
    end

    it 'does not touch arrays floats' do
      args = {x: [156.2]}
      needed_params = [:x]
      opts = @deck.send(:convert_units, args, needed_params)
      expect(opts).to eq({ :x => [156.2] })
    end

    it 'converts array of all inches' do
      args = {x: ['1in', '2in']}
      needed_params = [:x]
      opts = @deck.send(:convert_units, args, needed_params)
      expect(opts).to eq({:x => [300.0, 600.0] }) #assume 300dpi default
    end

    it 'converts array of some inches' do
      args = {x: [156, '2in']}
      needed_params = [:x]
      opts = @deck.send(:convert_units, args, needed_params)
      expect(opts).to eq({:x => [156.0, 600.0]}) #assume 300dpi default
    end

    it 'handles whitespace' do
      args = {x: ['1in   ']}
      needed_params = [:x]
      opts = @deck.send(:convert_units, args, needed_params)
      expect(opts).to eq({:x => [300.0] }) #assume 300dpi default
    end

     it 'converts centimeters' do
      args = {x: ['2cm']}
      needed_params = [:x]
      opts = @deck.send(:convert_units, args, needed_params)
      expect(opts).to eq({:x => [236.2204722] }) #assume 300dpi default
    end

    it 'handles non-expading singletons' do
      args = {margin: '1in', trim: '1in', gap: '1in'}
      needed_params = [:margin, :trim, :gap]
      opts = @deck.send(:convert_units, args, needed_params)
      expect(opts).to eq({margin: 300, trim: 300, gap: 300}) #assume 300dpi default
    end

  end

  context '#rowify' do
    it 'does nothing on an integer' do
      opts = @deck.send(:rowify, {columns: 2, rows: 2})
      expect(opts).to eq({ columns: 2,
                           rows: 2
                        })
    end

    it 'computes properly on non-integer' do
      opts = @deck.send(:rowify, {columns: 1, rows: :infinite})
      expect(opts).to eq({ columns: 1,
                           rows: 2
                        })
    end
  end

  context '#faceify' do
    it 'is false on left' do
      opts = @deck.send(:faceify, {face: :left})
      expect(opts).to eq({ face: false })
    end

    it 'is true on right' do
      opts = @deck.send(:faceify, {face: 'Right'})
      expect(opts).to eq({ face: true })
    end

    it 'is false on anything else' do
      opts = @deck.send(:faceify, {face: 'flugelhorn'})
      expect(opts).to eq({ face: false })
    end
  end

  context '#formatify' do
    it 'sets format to nil when format is not set' do
      opts = @deck.send(:formatify, {foo: true})
      expect(opts).to eq({
        foo: true,
        format: [nil]
        })
    end

    it 'updates the format to array' do
      opts = @deck.send(:formatify, {format: :png})
      expect(opts).to eq({format: [:png]})
    end

    it 'updates the format to flattened array' do
      opts = @deck.send(:formatify, {format: [[:png]]})
      expect(opts).to eq({format: [:png]})
    end

  end

end
