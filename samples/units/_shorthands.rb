require_relative '../../lib/squib'

# Lots of DSL methods have shorthands that are accepted for
# x, y, width, and height parameters.
Squib::Deck.new(width: '0.5in', height: '0.25in') do
  background color: :white

  # middle for x and y will resolve to half the height
  text str: 'xymiddle', font: 'Sans Bold 3', hint: :red,
       x: 'middle', y: :middle

  # 'center' also works
  rect width: 30, height: 30,
       x: :center, y: 'center'

  # Applies to shapes
  triangle x1: 20, y1: 20,
           x2: 60, y2: 20,
           x3: :middle, y3: :middle

  # We can also do width-, height-, width/, height/
  rect x: 20, y: 5, stroke_color: :green,
  width: 'deck - 0.1in', height: 10

  rect x: 10, y: 50, width: 10, height: 'deck / 3',
       stroke_color: :purple

  # And middle+/-
  rect x: 'middle + 0.1in', y: 'center - 0.1in',
       width: '0.1in', height: '0.1in', fill_color: :blue

  # Layouts apply this too.
  use_layout file: 'shorthands.yml'
  rect layout: :example

  # HOWEVER! Shorthands don't combine in an "extends" situation,
  # e.g. this won't work:
  # parent:
  #   x: middle
  # child:
  #   extends: parent
  #   x: += 0.5in

  # These shorthands are not intended for every xywh parameter or
  # length parameter, see docs for when they do or do not apply.

  save_png prefix: 'shorthand_'
end
