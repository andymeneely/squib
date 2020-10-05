require_relative '../../lib/squib'

# Lots of DSL methods have shorthands that are accepted for 
# x, y, width, and height parameters. 
Squib::Deck.new(width: '0.5in', height: '0.25in') do
  background color: :white

  text str: 'xymiddle', font: 'Sans Bold 3', hint: :red, 
       x: 'middle', y: :middle
       
  # 'center' also works
  rect width: 30, height: 30, 
       x: :center, y: 'center'

  # Layouts apply this too.
  use_layout file: 'shorthands.yml'
  rect layout: :example

  # The x and y coordinates can also be "centered", assuming the 

  # HOWEVER! Shorthands don't combine in an "extends" situation, 
  # e.g. this won't work: 
  # parent:
  #   x: middle 
  # child: 
  #   extends: parent 
  #   x: += 0.5in

  save_png prefix: 'shorthand_'
end
