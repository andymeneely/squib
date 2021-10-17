# typed: false
require_relative 'docs_helper'

describe Squib::DSL do
  context 'methods' do

    (Squib::DSL.constants - [:Text]).each do |m|
      it "accepted params for #{m} are in the docs" do
        accepted_params = Squib::DSL.const_get(m).accepted_params.sort
        documented_opts = documented_options(m).sort
        expect(accepted_params).to eq(documented_opts)
      end
    end

    it "accepted params for text and embedding options are in the docs" do
      accepted_params = Squib::DSL::Text.accepted_params
      accepted_params += Squib::TextEmbed.accepted_params
      accepted_params.sort!
      accepted_params.uniq!
      documented_opts = documented_options(:Text).sort.uniq
      documented_opts -= %i( embed.png embed.svg )
      expect(accepted_params).to eq(documented_opts)
    end

  end
end
