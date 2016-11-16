require 'cairo'
require_relative 'graphics/cairo_context_wrapper'

module Squib
  # Back end graphics. Private.
  class Card

    # :nodoc:
    # @api private
    attr_reader :width, :height, :backend, :svgfile, :index

    # :nodoc:
    # @api private
    attr_accessor :cairo_surface, :cairo_context

    # :nodoc:
    # @api private
    def initialize(deck, width, height, index=-1)
      @deck          = deck
      @width         = width
      @height        = height
      @backend       = deck.backend
      @index         = index
      @svgfile       = "#{deck.dir}/#{deck.prefix}#{deck.count_format % index}.svg"
      @cairo_surface = make_surface(@svgfile, @backend)
      @cairo_context = Squib::Graphics::CairoContextWrapper.new(Cairo::Context.new(@cairo_surface))
      @cairo_context.antialias = deck.antialias
    end

    # :nodoc:
    # @api private
    def make_surface(svgfile, backend)
      case backend.downcase.to_sym
      when :memory
        Cairo::ImageSurface.new(@width, @height)
      when :svg
        Dir.mkdir @deck.dir unless Dir.exists?(@deck.dir)
        Cairo::SVGSurface.new(svgfile, @width, @height)
      else
        Squib.logger.fatal "Back end not recognized: '#{backend}'"
        abort
      end
    end

  # A save/restore wrapper for using Cairo
  # :nodoc:
  # @api private
    def use_cairo(&block)
      @cairo_context.save
      block.yield(@cairo_context)
      @cairo_context.restore
    end

    def finish!
      begin
        @cairo_surface.finish
      rescue Cairo::SurfaceFinishedError
        # do nothin - if it's already finished that's fine
      end
    end

    ########################
    ### BACKEND GRAPHICS ###
    ########################
    require_relative 'graphics/background'
    require_relative 'graphics/image'
    require_relative 'graphics/save_doc'
    require_relative 'graphics/save_images'
    require_relative 'graphics/shapes'
    require_relative 'graphics/showcase'
    require_relative 'graphics/text'

  end
end
