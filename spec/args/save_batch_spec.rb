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
        expect(save_batch).to have_attributes({dir: ['tocreate']})
        expect(Dir.exists? 'tocreate').to be true
      end
    end
  end

  context 'rotate' do
    it 'does nothing by default' do
      opts = {}
      save_batch.load! opts
      expect(save_batch[0]).to have_attributes({rotate: false, angle: 0})
    end

    it 'rotates by pi/2 with true' do
      opts = {rotate: true}
      save_batch.load! opts
      expect(save_batch[0]).to have_attributes({rotate: true, angle: Math::PI / 2})
    end

    it 'rotates by pi/2' do
      opts = {rotate: :clockwise}
      save_batch.load! opts
      expect(save_batch[0]).to have_attributes({rotate: true, angle: Math::PI / 2})
    end

    it 'rotates by pi/2 with counterclockwise' do
      opts = {rotate: :counterclockwise}
      save_batch.load! opts
      expect(save_batch[0]).to have_attributes({rotate: true, angle: 3 * Math::PI / 2})
    end

    it 'raises error on a number' do
      opts = {rotate: 5.0}
      expect { save_batch.load!(opts) }.to raise_error('invalid option to rotate: only [true, false, :clockwise, :counterclockwise]')
    end
  end

end
