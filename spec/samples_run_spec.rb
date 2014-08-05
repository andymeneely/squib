require 'spec_helper'
require 'squib'
require 'pp'

describe Squib do 

  context "all samples" do

    FILE_HASHES = {
      "basic_" => "2a58552c601fc579e528a5ee38ee25b3",
      "colors_" => "b785b979a21b9d3006a7f6dfe96cb3f2",
      "layout_" => "b03fa164549a46fc3c657366260d1463",
      "load_images_" => "1e01c021c05d9b31568b01657c176b0b",
      "ranges_" => "7899a803c0cdb1d38f4e07e1a5dfbc96",
      "sample-save-pdf" => "04276606dec31c6c517f6cef36266166",
      "sample_excel_" => "669005e6e2b85b173b1166cd0c6055dd",
      "shape_" => "fb7669f3c301db05985ce54aea839460",
      "text_" => "aa005d44783a9997a8729b5be24a52fd",
      "tgc_sample_" => "bf18efd9f33dce91e3936c24387f60d3",
      "units_" => "bc251c1858c6c821ae06415279a02f62"
    }

    def hashes_of(dir, file_prefixes)
      map = {}
      file_prefixes.each do |pre|
        hash = "" ; files = []
        Dir["#{dir}/#{pre}*"].each { |f| files << f }
        p files.sort
        files.sort.each{ |f| hash += Digest::MD5.file(f).hexdigest }
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