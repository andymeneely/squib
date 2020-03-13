require_relative 'docs_helper'

describe Squib::DSL do
  context 'methods' do

    Squib::DSL.constants.each do |m|
      it "accepted params for #{m} are in the docs" do
        accepted_params = Squib::DSL.const_get(m).accepted_params
        expect(accepted_params).to eq(documented_options(m))
      end
    end


  end
end
