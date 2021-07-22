require 'pango'
module Squib

  # List all system fonts that Cairo/Pango can see
  # Wow this call was convoluted...
  # Returns array of strings with the names of fonts
  module_function def system_fonts
    cc = Cairo::Context.new(Cairo::ImageSurface.new(0,0)) # empty image
    cc.create_pango_layout.context.families.map {|f| f.name }
  end

  # Prints out the system fonts in sorted order
  module_function def print_system_fonts
    puts "== DEBUG: Squib knows about these fonts =="
    puts system_fonts.sort
  end
end