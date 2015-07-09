# encoding: utf-8
require 'squib'
require 'pp'

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
  svg file: 'spanner.svg',     layout: :icon_left
  png file: 'shiny-purse.png', layout: :icon_middle
  svg file: 'spanner.svg',     layout: :icon_right

  # Squib has its own, richer merge key: "extends"
  rect fill_color: :black, layout: :bonus
  rect fill_color: :white, layout: :bonus_inner
  text str: 'Extends!',    layout: :bonus_text

  # Strings can also be used to specify a layout (e.g. from a data file)
  text str: 'subtitle', layout: 'subtitle'

  # For debugging purposes, you can always print out the loaded layout
  # require 'pp'
  # pp layout

  save_png prefix: 'layout_'
end

Squib::Deck.new(layout: ['custom-layout.yml', 'custom-layout2.yml']) do
  text str: 'The Title',       layout: :title       # from custom-layout.yml
  text str: 'The Subtitle',    layout: :subtitle    # redefined in custom-layout2.yml
  text str: 'The Description', layout: :description # from custom-layout2.yml
  save_png prefix: 'layout2_'
end

# Built-in layouts are easy to use and extend
Squib::Deck.new(layout: 'playing-card.yml') do
  text str: "A\u2660",      layout: :bonus_ul, font: 'Sans bold 100', hint: :red
  text str: "A\u2660",      layout: :bonus_lr, font: 'Sans bold 100', hint: :red
  text str: "artwork here", layout: :art, hint: :red
  save_png prefix: 'layout_builtin_playing_card_'
end

# Built-in layouts are easy to use and extend
Squib::Deck.new(layout: 'hand.yml') do
  %w(title bonus1 bonus2 bonus3 bonus4 bonus5
    description snark art).each do |icon|
    text str: icon.capitalize, layout: icon,
         hint: :red, valign: 'middle', align: 'center'
  end
  png file: 'pokercard.png', alpha: 0.5
  save_png prefix: 'layout_builtin_hand_'
end
