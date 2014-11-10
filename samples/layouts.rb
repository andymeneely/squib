require 'squib'

Squib::Deck.new(layout: 'custom-layout.yml') do
  background color: :white
  hint text: :cyan

  # Layouts are YAML files that specify any option as a default
  rect layout: :frame

  # You can also override a given layout entry in the command
  circle layout: :frame, x: 50, y: 50, radius: 25

  # Lots of commands have the :layout option
  text str: 'The Title', layout: :title

  # Layouts also support YAML merge keys toreuse settings
  svg file: 'spanner.svg', layout: :icon_left
  png file: 'shiny-purse.png', layout: :icon_middle
  svg file: 'spanner.svg', layout: :icon_right

  # Squib has its own, richer merge key: "extends"
  rect fill_color: :black, layout: :bonus
  rect fill_color: :white, layout: :bonus_inner
  text str: 'Extends!',    layout: :bonus_text

  # Strings can also be used to specify a layout (e.g. from a data file)
  text str: 'subtitle', layout: 'subtitle'

  # For debugging purposes, you can always print out the loaded layout
  #require 'pp'
  #pp @layout

  save_png prefix: 'layout_'
end
