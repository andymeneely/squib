require 'squib'

orig = Cairo::ImageSurface.new(100,100)
orig_cc = Cairo::Context.new(orig)
orig_cc.circle(50,50, 30)
orig_cc.set_source_color(:red)
orig_cc.fill

orig.write_to_png '_output/blend_orig.png'

new_img = Cairo::ImageSurface.new(120, 120)
new_cc = Cairo::Context.new(new_img)
new_cc.set_source_color(:black)
new_cc.rectangle(0,0,120,120)
new_cc.fill
new_cc.set_source orig
new_cc.operator = :dest_in
new_cc.paint

new_img.write_to_png '_output/blend_new.png'