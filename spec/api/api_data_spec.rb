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

  context '#xlsx' do
    it 'loads basic xlsx data' do
      expect(Squib.xlsx(file: xlsx_file('basic.xlsx'))).to eq({
          'Name'           => %w(Larry Curly Mo),
          'General Number' => %w(1 2 3), #general types always get loaded as strings with no conversion
          'Actual Number'  =>  [4.0, 5.0, 6.0], #numbers get auto-converted to integers
          })
    end

    it 'loads xlsx with formulas' do
      expect(Squib.xlsx(file: xlsx_file('formulas.xlsx'))).to eq({
        'A'   => %w(1 2),
        'B'   => %w(3 4),
        'Sum' => %w(4 6),
        })
    end

  end
end