require_relative 'docs_helper'

describe Squib::DSL do
  context 'methods' do

    Squib::DSL.constants.each do |m|
      it "accepted params for #{m} are in the docs" do
        accepted_params = Squib::DSL.const_get(m).accepted_params.sort
        documented_opts = documented_options(m).sort
        expect(accepted_params).to eq(documented_opts)
      end
    end


  end
end
