# encoding: UTF-8

require 'spec_helper'
require 'squib/import/data_frame'

describe Squib::DataFrame do
  let(:basic) do
    {
      'Name' => ['Mage', 'Rogue', 'Warrior'],
      'Cost' => [1, 2, 3],
    }
  end

  let(:uneven) do
     {
       'Name' => ['Mage', 'Rogue', 'Warrior'],
       'Cost' => [1, 2],
     }
  end

  let(:whitespace) do
     {
       'Name \n\r\t' => ['  Mage \t\r\n'],
     }
  end

  let(:defined) do
    {
      'nrows' => [1,2,3],
    }
  end

  context 'is Enumerable and like a hash, so it' do
    it 'responds to each' do
      expect(subject).to respond_to(:each)
    end

    it 'responds to any?' do
      expect(subject.any?).to be false
    end

    it 'responds to []' do
      data = Squib::DataFrame.new basic
      expect(data['Cost']).to eq([1, 2, 3])
    end

    it 'responds to []=' do
      data = Squib::DataFrame.new basic
      data[:a] = 2
      expect(data[:a]).to eq(2)
    end
  end

  context :columns do
    it 'provides a list of columns' do
      data = Squib::DataFrame.new basic
      expect(data.columns).to eq %w(Name Cost)
    end
  end

  context :ncolumns do
    it 'provides column count' do
      data = Squib::DataFrame.new basic
      expect(data.ncolumns).to eq 2
    end
  end

  context :row do
    it 'returns a hash of each row' do
      data = Squib::DataFrame.new basic
      expect(data.row(0)).to eq ({'Name' => 'Mage', 'Cost' => 1})
      expect(data.row(1)).to eq ({'Name' => 'Rogue', 'Cost' => 2})
    end

    it 'returns nil for uneven data' do
      data = Squib::DataFrame.new uneven
      expect(data.row(2)).to eq ({'Name' => 'Warrior', 'Cost' => nil})
    end
  end

  context :nrows do
    it 'returns a row count on even data' do
      data = Squib::DataFrame.new basic
      expect(data.nrows).to eq 3
    end

    it 'returns largest row count on uneven data' do
      data = Squib::DataFrame.new basic
      expect(data.nrows).to eq 3
    end
  end

  context :json do
    it 'returns quoty json' do
      data = Squib::DataFrame.new basic
      expect(data.to_json).to eq "{\"Name\":[\"Mage\",\"Rogue\",\"Warrior\"],\"Cost\":[1,2,3]}"
    end

    it 'returns pretty json' do
      data = Squib::DataFrame.new basic
      str = <<-EOS
{
  "Name": [
    "Mage",
    "Rogue",
    "Warrior"
  ],
  "Cost": [
    1,
    2,
    3
  ]
}
EOS
      expect(data.to_pretty_json).to eq str.chomp
    end
  end

  context :def_column do
    it 'creates name for Name column' do
      data = Squib::DataFrame.new basic
      expect(data).to respond_to(:name)
      expect(data.name).to eq %w(Mage Rogue Warrior)
      expect(data.cost).to eq [1, 2, 3]
    end

    it 'does not redefine methods' do
      data = Squib::DataFrame.new defined
      expect(data).to respond_to(:nrows)
      expect(data.nrows).to eq 3
    end

    it 'defines a new column from empty data frame' do
      data = Squib::DataFrame.new
      expect(data).not_to respond_to(:snark)
      data['snark'] = [1,2,3]
      expect(data.snark).to eq [1,2,3]
    end
  end

  context :snake_case do
    subject { Squib::DataFrame.new }
    it 'strips leading & trailing whitespace' do
      expect(subject.send(:snake_case, '  A ')).to eq :a
    end

    it 'converts space to _' do
      expect(subject.send(:snake_case, 'A b')).to eq :a_b
    end

    it 'handles multiwhitespace' do
      expect(subject.send(:snake_case, 'A     b')).to eq :a_b
    end

    it 'handles camelcase' do
      expect(subject.send(:snake_case, 'fooBar')).to eq :foo_bar
    end

    it 'handles camelcase with multiple capitals' do
      expect(subject.send(:snake_case, 'FOOBar')).to eq :foo_bar
    end
  end

  context :col? do
    it 'returns true if a column exists' do
      data = Squib::DataFrame.new basic
      expect(data.col? 'Name').to be true
    end

    it 'returns false if a column does not exist' do
      data = Squib::DataFrame.new basic
      expect(data.col? 'ROUS').to be false
    end
  end

  context :wrap_n_pad do
    subject { Squib::DataFrame.new basic }

    it 'returns a handles a single line' do
      expect(subject.send(:wrap_n_pad, 'a', 3)).
        to eq "| a                                  |\n"
    end

    it 'wraps multiple a lines at 34 characters' do
      expect(subject.send(:wrap_n_pad, 'a' * 40, 3)).
        to eq <<-EOS
| aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa |
    | aaaaaa                             |
EOS
    end
  end

  context :to_pretty_text do

    let(:verbose) do
      {
        'Name' => ['Mage', 'Rogue', 'Warrior'],
        'Cost' => [1, 2, 3],
        'Description' => [
          'Magic, dude.',
          'I like to be sneaky',
          'I have a long story to tell to test the word-wrapping ability of pretty text formatting.'
          ],
        'Snark' => [nil, '', ' ']
      }
    end

    it 'returns fun ascii art of the card' do
      data = Squib::DataFrame.new verbose
      expect(data.to_pretty_text).to eq <<-EOS
            ╭------------------------------------╮
       Name | Mage                               |
       Cost | 1                                  |
Description | Magic, dude.                       |
      Snark |                                    |
            ╰------------------------------------╯
            ╭------------------------------------╮
       Name | Rogue                              |
       Cost | 2                                  |
Description | I like to be sneaky                |
      Snark |                                    |
            ╰------------------------------------╯
            ╭------------------------------------╮
       Name | Warrior                            |
       Cost | 3                                  |
Description | I have a long story to tell to tes |
            | t the word-wrapping ability of pre |
            | tty text formatting.               |
      Snark |                                    |
            ╰------------------------------------╯
EOS
    end

    let(:utf8_fun) do
      {
      'Fun with UTF8!' => ['👊'],
      }
    end

    it 'is admittedly janky with multibyte chars' do
      # I hate how Ruby handles multibyte chars. Blech!
      data = Squib::DataFrame.new utf8_fun
      expect(data.to_pretty_text).to eq <<-EOS
               ╭------------------------------------╮
Fun with UTF8! | 👊                                  |
               ╰------------------------------------╯
EOS
    end

    it 'does not pad the data' do
      data = Squib::DataFrame.new
      data['a'] = ['b', 'c']
      expect(data.to_pretty_text.size).to be > 0
      expect(data.columns).to eq ['a']
      expect(data['a']).to eq ['b', 'c']
    end
  end

end
