require 'spec_helper'
require 'squib/args/input_file'

describe Squib::Args::InputFile do
  subject(:ifile) {Squib::Args::InputFile.new}

  context 'validate_file' do

    it 'allows a file if it exists' do
      args = { file: __FILE__ } # I code therefore I am.
      ifile.load!(args, expand_by: 1)
      expect(ifile).to have_attributes(file: [File.expand_path(__FILE__)])
    end

    it 'raises on non-existent file' do
      args = { file: 'foo.rb' }
      expect { ifile.load!(args, expand_by: 1) }.to raise_error("File #{File.expand_path('foo.rb')} does not exist!")
    end

  end

  context 'layouts' do
    let(:layout) do
      { 'attack' => { 'file' => __FILE__ },
        'defend' => { 'file' => 'lib/squib.rb' } } #these files DEFINITELY exist
    end

    it 'allows layout expansion' do
      args = { layout: ['attack', 'defend'] }
      ifile.load!(args, expand_by: 2, layout: layout)
      expect(ifile[0].file).to end_with(__FILE__)
      expect(ifile[1].file).to end_with('lib/squib.rb')
    end
  end

end
