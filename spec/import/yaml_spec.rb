require 'spec_helper'

describe Squib::Deck do
  context '#yaml' do
    it 'loads basic data' do
      expect(Squib.yaml(file: yaml_file('basic.yml')).to_h).to eq({
        'Name'           => %w(Larry Curly Mo),
        'Number' => [4.0, 5.0, 6.0], # numbers get auto-converted to integers
        })
    end

    it 'explodes quantities' do
     expect(Squib.yaml(explode: 'qty', file: yaml_file('qty.yml')).to_h).to eq({
        'name' => %w(ha ha he),
        'qty'  => [2, 2, 1],
        })
    end

    it 'handles silence' do
     expect(Squib.yaml(file: yaml_file('nilly.yml')).to_h).to eq({
        'name' => %w(foo bar),
        'desc'  => [nil, 'Hello'],
        })
    end

    it 'yields to block when given' do
      data = Squib.yaml(file: yaml_file('basic.yml')) do |header, value|
        case header
        when 'Name'
          'he'
        when 'Number'
          value * 2
        else
          'ha'
        end
      end
      expect(data.to_h).to eq({
        'Name'   => %w(he he he),
        'Number' => [8.0, 10.0, 12.0],
        })
    end
  end
end
