require 'squib'

Squib::Deck.new do
  background color: :white

  grid x: 10, y: 10, width: 50,  height: 50,  stroke_color: '#0066FF', stroke_width: 1.5
  grid x: 10, y: 10, width: 200, height: 200, stroke_color: '#0066FF', stroke_width: 3

  rect x: 305, y: 105, width: 200, height: 50, dash: '4 2'

  rect x: 300, y: 300, width: 400, height: 400,
       fill_color: :blue, stroke_color: :red, stroke_width: 50.0,
       join: 'bevel'

  circle x: 600, y: 600, radius: 75,
         fill_color: :gray, stroke_color: :green, stroke_width: 8.0

  triangle x1: 50, y1: 50,
           x2: 150, y2: 150,
           x3: 75, y3: 250,
           fill_color: :gray, stroke_color: :green, stroke_width: 3.0

  line x1: 50, y1: 550,
       x2: 150, y2: 650,
       stroke_width: 25.0

  curve x1: 50,  y1: 850, cx1: 150, cy1: 700,
        x2: 625, y2: 900, cx2: 150, cy2: 700,
        stroke_width: 12.0, stroke_color: :cyan,
        fill_color: :burgundy, cap: 'round'

  ellipse x: 50, y: 925, width: 200, height: 100,
          stroke_width: 5.0, stroke_color: :cyan,
          fill_color: :burgundy

  star x: 300, y: 1000, n: 5, inner_radius: 15, outer_radius: 40,
       fill_color: :cyan, stroke_color: :burgundy, stroke_width: 5

  #default draw is fill-then-stroke. Can be changed to stroke-then-fill
  star x: 375, y: 1000, n: 5, inner_radius: 15, outer_radius: 40,
       fill_color: :cyan, stroke_color: :burgundy,
       stroke_width: 5, stroke_strategy: :stroke_first

  polygon x: 500, y: 1000, n: 5, radius: 25, angle: Math::PI / 2,
          fill_color: :cyan, stroke_color: :burgundy, stroke_width: 2

  save_png prefix: 'shape_'
end
