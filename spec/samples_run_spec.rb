require 'spec_helper'
require 'squib'

describe Squib do 

  context "all samples" do

    FILE_HASHES = {
      "basic_" => "2a35fa3bb121fe188c44d9b73cb7dcd3",
      "colors_" => "8917ed746d12b5d8bdc971415913a286",
      "layout_" => "4645a9cc0dc39d7ea673edafe9d8d30d",
      "load_images_" => "1e01c021c05d9b31568b01657c176b0b",
      "ranges_" => "614e439da81923df2b6e2458e5b389e3",
      "sample-save-pdf" => "d83a01103fa9e1e75706e2156d8f74ab",
      "sample_excel_" => "7aacc3f82073302aba698660f912ee40",
      "shape_" => "fb7669f3c301db05985ce54aea839460",
      "text_" => "ea924a806bda2f39ed5becb9c6c911b7",
      "tgc_sample_" => "dce2d03e0ea0647f9ec635ab601a4651",
      "units_" => "bc251c1858c6c821ae06415279a02f62"
    }

    def hashes_of(dir, file_prefixes)
      map = {}
      file_prefixes.each do |pre|
        hash = ""
        Dir["#{dir}/#{pre}*"].each do |file|
          hash += Digest::MD5.hexdigest(File.read(file))   
        end
        map[pre] = Digest::MD5.hexdigest(hash)
      end
      map
    end

    it "should execute with no errors" do
      samples = File.expand_path('../samples', File.dirname(__FILE__))
      Dir["#{samples}/**/*.rb"].each do |sample|
        Dir.chdir(samples) do #to save to _output
          require_relative "../samples/#{File.basename(sample)}"
        end
      end
      expect(hashes_of("#{samples}/_output", FILE_HASHES.keys)).to eq(FILE_HASHES)
    end

  end    

end