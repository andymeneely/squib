require 'squib'

# This is a more advanced example of Sprues
# (mostly so we can have a torturous regression test)
#  - Uses a custom sprue
#  - Weird rotations
#  - Center-positioned
#  - Multiple pages
Squib::Deck.new(cards: 6, width: '2.2in', height: '2.1in') do
  background color: :blue #blue never shows up! Yay clipping...
  rect stroke_width: 5, stroke_color: :red, fill_color: :salmon
  cut_zone margin: '0.125in',
           stroke_width: 2, stroke_color: :purple

  circle x: width/2, y: height/2, radius: 20 # midpoint

  text str: (0..9).map{ |i| "Card #{i}\n\n" },
       font: 'Sans 32', align: :center, valign: :middle,
       height: :deck, width: :deck
  
  save_sheet sprue: 'my_sprues/weird_sprue.yml',
             trim: '0.2in', trim_radius: '10pt',
             prefix: "advanced_sprues_"
end
