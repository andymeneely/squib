require 'spec_helper'
require 'squib/args/save_batch'

describe Squib::Args::SaveBatch do
  subject(:save_batch) {Squib::Args::SaveBatch.new}

  context 'dir' do

    it 'is created if not exists (and warns)' do
      opts = {dir: 'tocreate'}
      Dir.chdir(output_dir) do
        FileUtils.rm_rf('tocreate', secure: true)
        expect(Squib.logger).to receive(:warn).with("Dir 'tocreate' does not exist, creating it.").once
        save_batch.load! opts
        expect(save_batch).to have_attributes({dir: 'tocreate'})
        expect(Dir.exists? 'tocreate').to be true
      end
    end

  end
end
