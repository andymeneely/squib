require 'cairo'
require 'pango'
require 'rsvg2'

svg = RSVG::Handle.new_from_file('spanner.svg')
pdf = Cairo::PDFSurface.new("_output/blahblah2.pdf",8.5*300, 11*300)
cxt = Cairo::Context.new(pdf)
cxt.translate(1900,500)
cxt.render_rsvg_handle(svg, nil)
cxt.translate(-500,0)
cxt.render_rsvg_handle(svg, nil)