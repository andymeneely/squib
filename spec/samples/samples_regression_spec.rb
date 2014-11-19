require 'spec_helper'
require 'squib'
require 'pp'

describe Squib do

  context 'samples' do
    it 'should execute with no errors' do
      allow(ProgressBar).to receive(:create).and_return(Squib::DoNothing.new)
      samples = File.expand_path('../../samples', File.dirname(__FILE__))
      Dir["#{samples}/**/*.rb"].each do |sample|
        Dir.chdir(samples) do #to save to _output
          load sample
        end
      end
    end

    it 'did not change against regression logs' do
      samples = File.expand_path('../../samples', File.dirname(__FILE__))
      Dir["#{samples}/**/*.rb"].each do |sample|
        sample_name = File.basename(sample)
        header = "=== #{sample_name} ===\n"
        Dir.chdir(samples) do #to save to _output
          strio = StringIO.new
          strio << header
          mock_cairo(strio)
          load sample
          test_file_str = ""
          # Use this to overwrite the regression with current state
          # Use ONLY temporarily after you are happy with the new sample log
          # File.open(sample_regression_file(sample_name), 'w+') do |f|
          #   f.write(strio.string.force_encoding("UTF-8")) # write back out to expected file
          # end
          test_file_str << File.open(sample_regression_file(sample_name)).read.force_encoding("UTF-8")
          expect(strio.string).to eq(test_file_str)
        end
      end
    end

  end

end