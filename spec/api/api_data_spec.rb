require 'spec_helper'

describe Squib::Deck do
  context '#csv' do
    it 'loads basic csv data' do
      expect(Squib.csv(file: csv_file('basic.csv'))).to eq({
        'h1' => [1, 3],
        'h2' => [2, 4]
        })
    end

    it 'collapses duplicate columns and warns' do
      expect(Squib.logger).to receive(:warn)
        .with('CSV duplicated the following column keys: h1,h1')
      expect(Squib.csv(file: csv_file('dup_cols.csv'))).to eq({
        'h1' => [1, 3],
        'h2' => [5, 7],
        'H2' => [6, 8],
        'h3' => [9, 10],
        })
    end

    it 'handles spaces properly' do
      expect(Squib.csv(file: csv_file('with_spaces.csv'))).to eq({
        'With Spaces' => ['a b c      ', 3],
        'h2' => [2, 4],
        'h3' => [3, nil]
        })
    end
  end
end