require 'squib'

Squib::Deck.new do
  background color: :white
  text str: "Built at #{Time.now}"
  svg file: 'robot-golem.svg'
  save_png prefix: 'character_'
end
