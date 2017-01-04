# encoding: UTF-8
require 'squib'

data = { 'name' => ['Thief', 'Grifter', 'Mastermind'],
        'level' => [1, 2, 3] }
longtext = "This is left-justified text, with newlines.\nWhat do you know about tweetle beetles? well... When tweetle beetles fight, it's called a tweetle beetle battle. And when they battle in a puddle, it's a tweetle beetle puddle battle. AND when tweetle beetles battle with paddles in a puddle, they call it a tweetle beetle puddle paddle battle. AND... When beetles battle beetles in a puddle paddle battle and the beetle battle puddle is a puddle in a bottle... ..they call this a tweetle beetle bottle puddle paddle battle muddle."

Squib::Deck.new(width: 825, height: 1125, cards: 3) do
  background color: :white
  rect x: 15, y: 15, width: 795, height: 1095, x_radius: 50, y_radius: 50
  rect x: 30, y: 30, width: 128, height: 128, x_radius: 25, y_radius: 25

  # Arrays are rendered over each card
  text str: data['name'], x: 250, y: 55, font: 'Arial weight=900 54'
  text str: data['level'], x: 65, y: 40, font: 'Arial 72', color: :burnt_orange

  text str: 'Font strings are expressive!', x:65, y: 200,
       font: 'Impact bold italic 36'

  text str: 'Font strings are expressive!', x:65, y: 300,
       font: 'Arial,Verdana weight=900 style=oblique 36'

  text str: 'Font string sizes can be overridden per card.', x: 65, y: 350,
       font: 'Impact 36', font_size: [16, 20, 24]

  text str: 'This text has fixed width, fixed height, center-aligned, middle-valigned, and has a red hint',
       hint: :red,
       x: 65, y: 400,
       width: 300, height: 125,
       align: :center, valign: 'MIDDLE', # these can be specified with case-insenstive strings too
       font: 'Serif 16'

  extents = text str: 'Ink extent return value',
       x: 65, y: 550,
       font: 'Sans Bold', font_size: [16, 20, 24]
  margin = 10
  # Extents come back as an array of hashes, which can get split out like this
  ws = extents.inject([]) { |arr, ext| arr << ext[:width] + 10; arr }
  hs = extents.inject([]) { |arr, ext| arr << ext[:height] + 10; arr }
  rect x: 65 - margin / 2, y: 550 - margin / 2,
       width: ws, height: hs,
       radius: 10, stroke_color: :black

  # If width & height are defined and the text will overflow the box, we can ellipsize.
  text str: "Ellipsization!\nThe ultimate question of life, the universe, and everything to life and everything is 42",
       hint: :green, font: 'Arial 22',
       x: 450, y: 400,
       width: 280, height: 180,
       ellipsize: true

  # Text hints are guides for showing you how your text boxes are laid out exactly
  hint text: :cyan
  set font: 'Serif 20' # Impacts all future text calls (unless they specify differently)
  text str: 'Text hints & fonts are globally togglable!', x: 65, y: 625
  set font: :default # back to Squib-wide default
  hint text: :off
  text str: 'See? No hint here.',
        x: 565, y: 625,
        font: 'Arial 22'

  # Text can be rotated, in radians, about the upper-left corner of the text box.
  text str: 'Rotated',
        x: 565, y: 675, angle: 0.2,
        font: 'Arial 18', hint: :red

  # Text can be justified, and have newlines
  text str: longtext, font: 'Arial 16',
       x: 65, y: 700,
       width: '1.5in', height: inches(1),
       justify: true, spacing: -6

  # Here's how you embed images into text.
  # Pass a block to the method call and use the given context
  embed_text = 'Embedded icons! Take 1 :tool: and gain 2:health:. If Level 2, take 2 :tool:'
  text(str: embed_text, font: 'Sans 18',
       x: '1.8in', y: '2.5in', width: '0.85in',
       align: :left, ellipsize: false) do |embed|
    embed.svg key: ':tool:',   width: 28, height: 28, file: 'spanner.svg'
    embed.svg key: ':health:', width: 28, height: 28, file: 'glass-heart.svg'
  end

  text str: 'Fill n <span fgcolor="#ff0000">stroke</span>',
       color: :green, stroke_width: 2.0, stroke_color: :blue,
       x: '1.8in', y: '2.9in', width: '0.85in', font: 'Sans Bold 26', markup: true

  text str: 'Stroke n <span fgcolor="#ff0000">fill</span>',
       color: :green, stroke_width: 2.0, stroke_color: :blue, stroke_strategy: :stroke_first,
       x: '1.8in', y: '3.0in', width: '0.85in', font: 'Sans Bold 26', markup: true

  text str: 'Dotted',
       color: :white, stroke_width: 2.0, dash: '4 2', stroke_color: :black,
       x: '1.8in', y: '3.1in', width: '0.85in', font: 'Sans Bold 26', markup: true
  #
  text str: "<b>Markup</b> is <i>quite</i> <s>'easy'</s> <span fgcolor=\"\#ff0000\">awesome</span>. Can't beat those \"smart\" 'quotes', now with 10--20% more en-dashes --- and em-dashes --- with explicit ellipses too...",
       markup: true,
       x: 50, y: 1000,
       width: 750, height: 100,
       valign: :bottom,
       font: 'Serif 18', hint: :cyan

  save prefix: 'text_options_', format: :png
end
