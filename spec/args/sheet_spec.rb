require 'spec_helper'
require 'squib/args/sheet'

describe Squib::Args::Sheet do

  context 'dsl overrides' do
    subject(:sheet) { Squib::Args::Sheet.new({}, {file: 'foo'}) }

    it 'works when specified' do
      sheet.load!({}) # go right to defaults
      expect(sheet.file).to eq( 'foo' ) # dsl method default override
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
      opts = {columns: 1, rows: :infinite}
      sheet.load! opts
      expect(sheet).to have_attributes( columns: 1, rows: 4 )
    end

    it 'computes properly on unspecified rows' do
      opts = {columns: 1}
      sheet.load! opts
      expect(sheet).to have_attributes( columns: 1, rows: 4 )
    end

    it 'computes properly on unspecified, too-big column' do
      opts = {}
      sheet.load! opts
      expect(sheet).to have_attributes( columns: 5, rows: 1 )
    end

    it 'fails on a non-integer column' do
      opts = {columns: :infinite}
      expect { sheet.load!(opts) }.to raise_error('columns must be an integer')
    end

    context 'margins' do
      subject(:sheet) { Squib::Args::Sheet.new({}, {}, 4) }

      it 'has the north on margin when not set' do
        opts = {}
        sheet.load! opts
        expect(sheet).to have_attributes(margin: 75, margin_north: 75,
                                         margin_south: 75, margin_east: 75,
                                         margin_west: 75)
      end

      it 'margin overrides everyone else' do
        opts = { margin: 1,
                 margin_north: 2,
                 margin_south: 3,
                 margin_east: 4,
                 margin_west: 5}
        sheet.load! opts
        expect(sheet).to have_attributes(margin: 1, margin_north: 1,
                                         margin_south: 1, margin_east: 1,
                                         margin_west: 1)
      end

      it 'individuals support units' do
        opts = { margin_north: '2in',
                 margin_south: '3in',
                 margin_east: '4in',
                 margin_west: '5in'}
        sheet.load! opts
        expect(sheet).to have_attributes(margin: 600, margin_north: 600,
                                         margin_south: 900, margin_east: 1200,
                                         margin_west: 1500)
      end

    end

  end

end
