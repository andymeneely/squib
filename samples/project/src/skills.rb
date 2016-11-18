require 'squib'

Squib::Deck.new do
  background color: :white
  text str: "Built at #{Time.now}"
  save_png prefix: 'skill_'
end
