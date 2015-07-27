require 'squib'

# This sample demonstrates the built-in layouts for Squib.
# Each card demonstrates a different built-in layout.
Squib::Deck.new(layout: 'fantasy.yml') do
  background color: 'white'

  set font: 'Times New Roman,Serif 32'
  hint text: '#333' # show extents of text boxes to demo the layout

  text str: 'fantasy.yml', layout: :title
  text str: 'ur',          layout: :upper_right
  text str: 'art',         layout: :art
  text str: 'type',        layout: :type
  text str: 'tr',          layout: :type_right
  text str: 'description', layout: :description
  text str: 'lr',          layout: :lower_right
  text str: 'll',          layout: :lower_left
  text str: 'credits',     layout: :copy

  rect layout: :safe
  rect layout: :cut
  save_png prefix: 'layouts_builtin_fantasy_'
end

Squib::Deck.new(layout: 'economy.yml') do
  background color: 'white'

  set font: 'Times New Roman,Serif 32'
  hint text: '#333' # show extents of text boxes to demo the layout

  text str: 'economy.yml', layout: :title
  text str: 'art',         layout: :art
  text str: 'description', layout: :description
  text str: 'type',        layout: :type
  text str: 'lr',          layout: :lower_right
  text str: 'll',          layout: :lower_left
  text str: 'credits',     layout: :copy

  rect layout: :safe
  rect layout: :cut
  save_png prefix: 'layouts_builtin_economy_'
end

# Stitch together a deck of all the above examples
Squib::Deck.new(cards: 2) do
  Dir.glob('_output/layouts_builtin_*.png').each.with_index do |file, i|
    png file: file, range: i
  end
  save_sheet prefix: 'layouts_builtinsheet_'
end
