require 'squib'

# This sample demonstrates the built-in layouts for Squib.
# Each card demonstrates a different built-in layout.
Squib::Deck.new(layout: 'fantasy.yml') do
  background color: 'white'

  set font: 'Times New Roman,Serif 10.5'
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

  set font: 'Times New Roman,Serif 10.5'
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

Squib::Deck.new(layout: 'hand.yml') do
  background color: 'white'
  %w(title bonus1 bonus2 bonus3 bonus4 bonus5 description
     snark art).each do |icon|
    text str: icon.capitalize, layout: icon,
         hint: :red, valign: 'middle', align: 'center'
  end
  save_png prefix: 'layouts_builtin_hand_'
end

Squib::Deck.new(layout: 'playing-card.yml') do
  background color: 'white'
  text str: "A\u2660", layout: :bonus_ul, font: 'Sans bold 33', hint: :red
  text str: "A\u2660", layout: :bonus_lr, font: 'Sans bold 33', hint: :red
  text str: 'artwork here', layout: :art, hint: :red
  save_png prefix: 'layouts_builtin_playing_card_'
end

Squib::Deck.new(layout: 'tuck_box.yml', width: 2325, height: 1950) do
  background color: 'white'
  rect layout: :top_rect
  rect layout: :bottom_rect
  rect layout: :right_rect
  rect layout: :left_rect
  rect layout: :back_rect
  rect layout: :front_rect
  curve layout: :front_curve

  save_png prefix: 'layouts_builtin_tuck_box_'
end

Squib::Deck.new(layout: 'party.yml') do
  background color: 'white'
  # hint text: :black # uncomment to see the text box boundaries

  rect layout: :title_box,
       fill_color: :deep_sky_blue, stroke_width: 0
  text str: "A SILLY NAME",  layout: :title
  text str: '✔',             layout: :type_icon
  text str: 'TYPE',          layout: :type
  text str: 'A Silly Name',  layout: :title_middle
  rect fill_color: :black,   layout: :middle_rect

  str = 'Rule or story text. Be funny ha ha ha this is a party.'
  text str: str, layout: :rule_top
  text str: str, layout: :rule_bottom

  text str: 'Tiny text', layout: :copyright

  rect layout: :safe
  rect layout: :cut
  save_png prefix: 'layouts_builtin_party_'
end
