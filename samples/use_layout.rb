require 'squib'

Squib::Deck.new(layout: 'custom-layout.yml') do 
  background color: :white
  hint text: :cyan

  # Layouts are YAML files that specify any option as a default
  rect layout: :frame

  # You can also override a given layout entry in the command
  circle layout: :frame, x: 50, y: 50, radius: 25

  # Any command with x-y-width-height options, we can use a custom layout
  text str: 'The Title', layout: :title

  # Layouts also support an "extends" attribute to reuse settings
  svg file: 'spanner.svg', layout: :icon_left
  png file: 'shiny-purse.png', layout: :icon_middle
  svg file: 'spanner.svg', layout: :icon_right

  # Strings can also be used to specify a layout (e.g. from a data file)
  text str: 'subtitle', layout: 'subtitle'

  # For debugging purposes, you can always print out the loaded layout
  # require 'pp'
  # pp @layout

  save_png prefix: 'layout_'
end