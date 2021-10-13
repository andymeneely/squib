require 'spec_helper'
require 'squib/args/input_file'

describe Squib::Args::InputFile do
  subject(:ifile) {Squib::Args::InputFile.new}

  context 'validate_file' do

    it 'allows a file if it exists' do
      args = { file: __FILE__ } # I code therefore I am.
      ifile.load!(args, expand_by: 1)
      expect(ifile.file).to eq([File.expand_path(__FILE__)])
    end

    it 'warns on non-existent file by default' do
      args = { file: 'foo.rb' }

      conf = double("conf", conf: Squib::Conf.new)
      expect(conf).to receive(:img_missing).and_return(:warn)
      expect(ifile).to receive(:deck_conf).and_return(conf)
      expect(Squib.logger).to receive(:warn).once

      expect(ifile.load!(args, expand_by: 1)).to have_attributes(file: [nil])
    end

    it 'uses placeholder when file does not exist but placeholder is non-nil and does exist' do
      args = { file: 'foo.rb', placeholder: __FILE__ }
      expect(Squib.logger).not_to receive(:warn)
      expect(ifile.load!(args, expand_by: 1).file).to eq([File.expand_path(__FILE__)])
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
