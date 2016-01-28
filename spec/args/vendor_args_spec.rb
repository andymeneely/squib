require 'spec_helper'

describe Squib::Args::VendorArgs do
  context "::base_options" do
    before(:each) do
      card = { "poker" => {width: '2.5in', height: '3.5in'} }
      allow(YAML).to receive(:load_file).and_return(card)
    end

    it "returns the width and height values for card matching the argument" do
      poker_size = { width: '2.5in', height: '3.5in' }
      expect(Squib::Args::VendorArgs.base_options("poker")).to eq(poker_size)
    end

    it "raises an error if the specified card is not found in the YAML file" do
      expect {Squib::Args::VendorArgs.base_options("not-a-card")}.to raise_error('Card type "not-a-card" is not supported.')
    end
  end

  context "::vendor_options" do
    before(:each) do
      cards = { "poker" => {width: '2.5in', height: '3.5in'}, "funky-card" => {width: '1in', height: '1in'}}
      allow(YAML).to receive(:load_file).and_return(cards)

      vendor = { "items" => "poker", "specs" => { bleed: ".125in", dpi: 100} }
      allow(YAML).to receive(:load_file).with(/ad_magic\.yml$/).and_return(vendor)
      allow(YAML).to receive(:load_file).with(/not-a-vendor\.yml$/).and_raise(SystemCallError.new "no such file")
    end

    it "returns vendor specs with data from a YAML file with the name of the specified vendor" do
      specs = { bleed: ".125in", dpi: 100 }
      expect(Squib::Args::VendorArgs.vendor_options("poker","ad_magic")).to eq(specs)
    end

    it "rescues a SystemCallError if no matching file exists and notifies the logger" do
      expect(Squib.logger).to receive :warn
      expect{ Squib::Args::VendorArgs.vendor_options("poker", "not-a-vendor") }.to_not raise_error
    end

    it "notifies the logger if the card type is not found in the vendor's file" do
      expect(Squib.logger).to receive :warn
      expect(Squib::Args::VendorArgs.vendor_options("funky-card", "ad_magic")).to be(nil)
    end

  end
end
