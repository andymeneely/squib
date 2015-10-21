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

    it 'strips spaces by default' do
      expect(Squib.csv(file: csv_file('with_spaces.csv'))).to eq({
        'With Spaces' => ['a b c', 3],
        'h2' => [2, 4],
        'h3' => [3, nil]
        })
    end

    it 'skips space stripping if told to' do
      expect(Squib.csv(strip: false, file: csv_file('with_spaces.csv'))).to eq({
        '  With Spaces  ' => ['a b c      ', 3],
        'h2' => [2, 4],
        'h3' => [3, nil]
        })
    end

    it 'explodes quantities' do
      expect(Squib.csv(file: csv_file('qty.csv'))).to eq({
        'Name'  => %w(Ha Ha Ha Ho),
        'Qty' => [3, 3, 3, 1],
        })
    end

    it 'explodes quantities on specified header' do
      expect(Squib.csv(explode: 'Quantity', file: csv_file('qty_named.csv'))).to eq({
        'Name'  => %w(Ha Ha Ha Ho),
        'Quantity' => [3, 3, 3, 1],
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

    it 'loads xlsm files with macros' do
      expect(Squib.xlsx(file: xlsx_file('with_macros.xlsm'))).to eq({
        'foo' => %w(8 10),
        'bar' => %w(9 11),
        })
    end

    it 'strips whitespace by default' do
      expect(Squib.xlsx(file: xlsx_file('whitespace.xlsx'))).to eq({
          'With Whitespace' => ['foo', 'bar', 'baz'],
        })
    end

    it 'does not strip whitespace when specified' do
      expect(Squib.xlsx(file: xlsx_file('whitespace.xlsx'), strip: false)).to eq({
          '                  With Whitespace                  ' => ['foo             ', '      bar', '   baz  '],
        })
    end

    it 'yields to block when given' do
      data = Squib.xlsx(file: xlsx_file('basic.xlsx')) do |header, value|
        case header
        when 'Name'
          'he'
        when 'Actual Number'
          value * 2
        else
          'ha'
        end
      end
      expect(data).to eq({
        'Name'           => %w(he he he),
        'General Number' => %w(ha ha ha),
        'Actual Number'  => [8.0, 10.0, 12.0],
        })
    end

    it 'explodes quantities' do
       expect(Squib.xlsx(explode: 'Qty', file: xlsx_file('explode_quantities.xlsx'))).to eq({
        'Name' => ['Zergling', 'Zergling', 'Zergling', 'High Templar'],
        'Qty'  => %w(3 3 3 1),
        })
    end

  end
end
