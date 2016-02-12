require 'spec_helper'

describe "Squib::Args::Bleed" do

    before(:each) do
      allow(Squib::Args::VendorArgs).to receive(:base_options).and_return({width: '1in', height: '1in'})
    end

  context "::add" do

    it "returns a value with bleed added to both sides" do
      expect(Squib::Args::Bleed.add 400, 50, 300).to eq(500)
    end
    it "converts units" do
      expect(Squib::Args::Bleed.add "1in", '0.125in', 400).to eq(500)
    end
  end

  context "::size" do
    it "calculates the bleed of the card" do
      expect(Squib::Args::Bleed.size "card_name", 500, 500, 400).to eq(50)
    end
    it "converts units" do
      expect(Squib::Args::Bleed.size "card_name", '1.25in', '1.25in', 400).to eq(50)
    end
    it "warns logger and returns 0 if bleed is uneven" do
      expect(Squib.logger).to receive :warn
      expect(Squib::Args::Bleed.size "card_name", '1.25in', 501, 400).to eq(0)
    end

  end
end
