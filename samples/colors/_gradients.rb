require 'squib'

Squib::Deck.new do
  # Just about anywhere Squib takes in a color it can also take in a gradient too
  # The x-y coordinates on the card itself,
  # and then color stops are defined between 0 and 1
  background color: '(0,0)(0,1125) #ccc@0.0 #111@1.0'
  line stroke_color: '(0,0)(825,0) #111@1.0 #ccc@0.0',
      x1: 0, y1: 600, x2: 825, y2: 600,
       stroke_width: 15

  # Radial gradients look like this
  circle fill_color: '(425,400,2)(425,400,120) #ccc@0.0 #111@1.0',
         x: 415, y: 415, radius: 100, stroke_color: '#0000'
  triangle fill_color: '(650,400,2)(650,400,120) #ccc@0.0 #111@1.0',
           stroke_color: '#0000',
           x1: 650, y1: 360,
           x2: 550, y2: 500,
           x3: 750, y3: 500

  # Gradients are also good for beveling effects:
  rect fill_color: '(0,200)(0,600) #111@0.0 #ccc@1.0',
       x: 30, y: 350, width: 150, height: 150,
       radius: 15, stroke_color: '#0000'
  rect fill_color: '(0,200)(0,600) #111@1.0 #ccc@0.0',
       x: 40, y: 360, width: 130, height: 130,
       radius: 15, stroke_color: '#0000'

  # Alpha transparency can be used too
  text str: 'Hello, world!', x: 75, y: 700, font: 'Sans Bold 72',
       color: '(0,0)(825,0) #000f@0.0 #0000@1.0'

  save_png prefix: 'gradient_'
end
