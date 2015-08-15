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

end
