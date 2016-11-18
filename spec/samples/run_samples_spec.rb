require 'spec_helper'
require 'squib'
require 'pp'

describe 'Squib samples' do

  Dir["#{samples_dir}/**/*.rb"].each do |sample|
    it "executes #{sample} with no errors", slow: true do
      allow(Squib.logger).to receive(:warn) {}
      allow(ProgressBar).to receive(:create).and_return(Squib::DoNothing.new)
      Dir.chdir(File.dirname(sample)) do
        load sample
      end
    end unless sample =~ /project/ # ignore our project sample, run it below
  end

end
