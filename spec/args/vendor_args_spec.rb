require 'spec_helper'

describe Squib::Args::VendorArgs do
  context "::base_options" do


    it "loads data from a YAML file" do
      expect(YAML) {Squib::Args::VendorArgs.base_options(:poker)}.to_receive(:load_file)

      expect { Squib::Args::VendorArgs.base_options(:poker) }.not_to raise_error
    end


    it "returns the width and height values for card matching the argument" do
      poker_size = { width: '2.5in', height: '3.5in' }
      expect(Squib::Args::VendorArgs.base_options(:poker)).to eq(poker_size)
    end

    it "raises an error if the specified card is not found in the YAML file"

  end

  context "::vendor_options" do

    it "loads data from a YAML file with the name of the specified vendor"

    it "rescues a SystemCallError if no matching file exists and notifies the logger"

    it "notifies the logger if the card type is not found in the vendor's file"

    it "returns the vendor specific specifications"
  end
end
