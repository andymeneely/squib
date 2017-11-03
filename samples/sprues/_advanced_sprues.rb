require 'squib'

# This is a more advanced example of Sprues
# (mostly so we can have a torturous regression test)
#  - Uses a custom sprue
#  - Weird rotations
#  - Center-positioned
#  - Uses per-card trim and trim_radius
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

  # Per-card trims just for funsies
  trims = ['0.2in'] * 9
  trims[0] = '0.3in'
  trims[3] = '0.4in'
  trim_radii = ['10pt'] * 9
  trim_radii[1] = '0.2in'
  trim_radii[3] = '0.75in'
  
  save_sheet sprue: 'my_sprues/weird_sprue.yml',
             trim: trims, trim_radius: trim_radii,
             prefix: "advanced_sprues_"
end
