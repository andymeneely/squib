require 'spec_helper'
require 'squib/args/sheet'

describe Squib::Args::Sheet do

  context 'dsl overrides' do
    subject(:sheet) { Squib::Args::Sheet.new({}, { file: 'foo' }) }

    it 'works when specified' do
      sheet.load!({}) # go right to defaults
      expect(sheet.file).to eq('foo') # dsl method default override
    end

  end

  context 'rows and colums' do
    subject(:sheet) { Squib::Args::Sheet.new({}, {}, 4) }

    it 'does nothing on a perfect fit' do
      opts = { columns: 2, rows: 2 }
      sheet.load! opts
      expect(sheet).to have_attributes(columns: 2, rows: 2)
    end

    it 'keeps both if specified' do
      opts = { columns: 1, rows: 1 }
      sheet.load! opts
      expect(sheet).to have_attributes(columns: 1, rows: 1)
    end

    it 'computes properly on non-integer' do
      opts = { columns: 1, rows: :infinite }
      sheet.load! opts
      expect(sheet).to have_attributes(columns: 1, rows: 4)
    end

    it 'computes properly on unspecified rows' do
      opts = { columns: 1 }
      sheet.load! opts
      expect(sheet).to have_attributes(columns: 1, rows: 4)
    end

    it 'computes properly on unspecified, too-big column' do
      opts = {}
      sheet.load! opts
      expect(sheet).to have_attributes(columns: 5, rows: 1)
    end

    it 'fails on a non-integer column' do
      opts = { columns: :infinite }
      expect { sheet.load!(opts) }.to raise_error('columns must be an integer')
    end
  end

  context 'crop marks' do
    subject(:sheet) { Squib::Args::Sheet.new({}, {}, 4) }

    it 'computes crop marks properly' do
      opts = {
        width: 1000,
        height: 1100,
        trim: 10,
        crop_margin_top: 20,
        crop_margin_left: 30,
        crop_margin_right: 40,
        crop_margin_bottom: 50,
      }
      expect(sheet.load!(opts).crop_coords(3,4, 300, 400)).to eq(
        [ {:x1=>43, :y1=>0, :x2=>43, :y2=>74},
          {:x1=>253, :y1=>0, :x2=>253, :y2=>74},
          {:x1=>43, :y1=>1100, :x2=>43, :y2=>1026},
          {:x1=>253, :y1=>1100, :x2=>253, :y2=>1026},
          {:x1=>0, :y1=>34, :x2=>74, :y2=>34},
          {:x1=>1000, :y1=>34, :x2=>926, :y2=>34},
          {:x1=>0, :y1=>344, :x2=>74, :y2=>344},
          {:x1=>1000, :y1=>344, :x2=>926, :y2=>344}]
      )
    end
  end
end
