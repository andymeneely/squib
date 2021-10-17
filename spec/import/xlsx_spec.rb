# typed: false
require 'spec_helper'

describe Squib::Deck do
  context '#xlsx' do
    it 'loads basic xlsx data' do
      expect(Squib.xlsx(file: xlsx_file('basic.xlsx')).to_h).to eq({
        'Name'           => %w(Larry Curly Mo),
        'General Number' => %w(1 2 3), # general types always get loaded as strings with no conversion
        'Actual Number' => [4.0, 5.0, 6.0], # numbers get auto-converted to integers
        })
    end

    it 'loads xlsx with formulas' do
      expect(Squib.xlsx(file: xlsx_file('formulas.xlsx')).to_h).to eq({
        'A'   => %w(1 2),
        'B'   => %w(3 4),
        'Sum' => %w(4 6),
        })
    end

    it 'loads xlsm files with macros' do
      expect(Squib.xlsx(file: xlsx_file('with_macros.xlsm')).to_h).to eq({
        'foo' => %w(8 10),
        'bar' => %w(9 11),
        })
    end

    it 'strips whitespace by default' do
      expect(Squib.xlsx(file: xlsx_file('whitespace.xlsx')).to_h).to eq({
          'With Whitespace' => ['foo', 'bar', 'baz'],
        })
    end

    it 'does not strip whitespace when specified' do
      expect(Squib.xlsx(file: xlsx_file('whitespace.xlsx'), strip: false).to_h).to eq({
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
      expect(data.to_h).to eq({
        'Name'           => %w(he he he),
        'General Number' => %w(ha ha ha),
        'Actual Number'  => [8.0, 10.0, 12.0],
        })
    end

    it 'explodes quantities' do
       expect(Squib.xlsx(explode: 'Quantity', file: xlsx_file('explode_quantities.xlsx')).to_h).to eq({
        'Name' => ['Zergling', 'Zergling', 'Zergling', 'High Templar'],
        'Quantity'  => %w(3 3 3 1),
        })
    end

  end  
end
