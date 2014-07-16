require 'cairo'

module Squib

	class Card
    attr_reader :width, :height
    attr_accessor :cairo_surface, :cairo_context

    def initialize(width, height)
      @width=width; @height=height
      @cairo_surface = Cairo::ImageSurface.new(width,height)
      @cairo_context = Cairo::Context.new(@cairo_surface)
    end

    ########################
    ### BACKEND GRAPHICS ###
    ########################
    require 'squib/graphics/background'
    require 'squib/graphics/save_doc'
    require 'squib/graphics/save_images'
    require 'squib/graphics/shapes'
    require 'squib/graphics/text'
    
	end

end