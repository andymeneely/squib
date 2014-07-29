require 'squib'

Squib::Deck.new(layout: 'custom-layout.yml') do 
  background color: :white

  # Layouts are YAML files that specify x, y, width, and height coordinates
  rect layout: :frame

  # You can also override a given layout entry in the command
  rect layout: :frame, width: 50, height: 50

  # Any command with x-y-width-height options, we can use a custom layout
  text str: 'The Title', layout: :title
  png file: 'shiny-purse.png', layout: :icon_left
  svg file: 'spanner.svg', layout: :icon_right

  # Strings can also be used in layouts
  text str: 'subtitle', layout: 'subtitle'

  save_png prefix: 'layout_'
end