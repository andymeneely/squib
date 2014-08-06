require 'spec_helper'
require 'squib'
require 'pp'

describe Squib do 

  context "all samples run without error" do
    it "should execute with no errors" do
      samples = File.expand_path('../samples', File.dirname(__FILE__))
      Dir["#{samples}/**/*.rb"].each do |sample|
        Dir.chdir(samples) do #to save to _output
          require_relative "../samples/#{File.basename(sample)}"
        end
      end
    end
  end    

end