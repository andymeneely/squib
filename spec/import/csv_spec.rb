# typed: false
require 'spec_helper'

describe Squib::Deck do
  context '#csv' do
    it 'loads basic csv data' do
      expect(Squib.csv(file: csv_file('basic.csv')).to_h.to_h).to eq({
        'h1' => [1, 3],
        'h2' => [2, 4]
        })
    end

    it 'collapses duplicate columns and warns' do
      expect(Squib.logger).to receive(:warn)
        .with('CSV duplicated the following column keys: h1,h1')
      expect(Squib.csv(file: csv_file('dup_cols.csv')).to_h.to_h).to eq({
        'h1' => [1, 3],
        'h2' => [5, 7],
        'H2' => [6, 8],
        'h3' => [9, 10],
        })
    end

    it 'strips spaces by default' do
      expect(Squib.csv(file: csv_file('with_spaces.csv')).to_h).to eq({
        'With Spaces' => ['a b c', 3],
        'h2' => [2, 4],
        'h3' => [3, nil]
        })
    end

    it 'skips space stripping if told to' do
      expect(Squib.csv(strip: false, file: csv_file('with_spaces.csv')).to_h).to eq({
        '  With Spaces  ' => ['a b c      ', 3],
        'h2' => [2, 4],
        'h3' => [3, nil]
        })
    end

    it 'explodes quantities' do
      expect(Squib.csv(file: csv_file('qty.csv')).to_h).to eq({
        'Name' => %w(Ha Ha Ha Ho),
        'qty' => [3, 3, 3, 1],
        })
    end

    it 'explodes quantities on specified header' do
      expect(Squib.csv(explode: 'Quantity', file: csv_file('qty_named.csv')).to_h).to eq({
        'Name' => %w(Ha Ha Ha Ho),
        'Quantity' => [3, 3, 3, 1],
        })
    end

    it 'loads inline data' do
      hash = Squib.csv(data: "h1,h2\n1,2\n3,4")
      expect(hash.to_h).to eq({
        'h1' => [1, 3],
        'h2' => [2, 4]
        })
    end

    it 'loads csv with newlines' do
      hash = Squib.csv(file: csv_file('newline.csv'))
      expect(hash.to_h).to eq({
        'title' => ['Foo'],
        'level' => [1],
        'notes' => ["a\nb"]
      })
    end

    it 'loads custom CSV options' do
      hash = Squib.csv(file: csv_file('custom_opts.csv'),
                       col_sep: '-', quote_char: '|')
      expect(hash.to_h).to eq({
        'x' => ['p'],
        'y' => ['q-r']
        })
    end

    it 'yields to block when given' do
      data = Squib.csv(file: csv_file('basic.csv')) do |header, value|
        case header
        when 'h1'
          value * 2
        else
          'ha'
        end
      end
      expect(data.to_h).to eq({
        'h1' => [2, 6],
        'h2' => %w(ha ha),
        })
    end

    it 'replaces newlines whenever its a string' do
      data = Squib.csv(file: csv_file('yield.csv')) do |header, value|
        if value.respond_to? :gsub
          value.gsub '%n', "\n"
        else
          value
        end
      end
      expect(data.to_h).to eq({
        'a' => ["foo\nbar", 1],
        'b' => [1, "blah\n"],
        })
    end

  end
end
