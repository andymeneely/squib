require 'squib'

Squib::Deck.new(cards: 2) do
  background color: :white

  # Outputs a hash of arrays with the header names as keys
  data = yaml file: 'sample.yaml'
  text str: data['Type'], x: 250, y: 55, font: 'Arial 54'
  text str: data['Level'], x: 65, y: 65, font: 'Arial 72'

  save format: :png, prefix: 'sample_yaml_'
end
