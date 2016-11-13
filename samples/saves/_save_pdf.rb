require 'squib'

Squib::Deck.new(cards: 8) do
  background color: :gray
  rect x: 37.5, y: 37.5, width: 750, height: 1050,
       x_radius: 37.5, y_radius: 37.5, stroke: 3.0, dash: '4 4'

   # Tests for crop marks
   save_pdf file: 'crops-default.pdf', crop_marks: true
   save_pdf file: 'crops-gapped.pdf', crop_marks: true, trim: 37.5, gap: 20

   # Test crop marks with all the bells and whistles
   rect x: '0.3in', y: '0.4in', width: '2in', height: '2.5in'
   save_pdf file: 'crops-custom.pdf', crop_marks: true, trim: 0, gap: 20,
      crop_stroke_dash: '5 5', crop_stroke_color: :red, crop_stroke_width: 4.0,
      crop_margin_left: '0.3in', crop_margin_right: '0.45in',
      crop_margin_top:  '0.4in', crop_margin_bottom: '0.85in'
end
