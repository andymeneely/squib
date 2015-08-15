require 'squib/args/card_range'
require 'squib/args/save_batch'
require 'squib/args/sheet'
require 'squib/args/showcase_special'

module Squib
  class Deck

    # Saves the given range of cards to either PNG or PDF
    #
    #
    # @option opts [Enumerable] range (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts [String] dir (_output) the directory for the output to be sent to. Will be created if it doesn't exist.
    # @option opts [Symbol] format (:png)  the format that this will be rendered too. Options `:pdf, :png`. Array of both is allowed: `[:pdf, :png]`
    # @option opts [String] prefix (card_) the prefix of the file name to be printed
    # @option opts [Boolean] rotate (false) PNG saving only. If true, the saved cards will be rotated 90 degrees clockwise. Intended to rendering landscape instead of portrait.
    # @return self
    # @api public
    def save(opts = {})
      save_png(opts) if Array(opts[:format]).include? :png
      save_pdf(opts) if Array(opts[:format]).include? :pdf
      self
    end

    # Saves the given range of cards to a PNG
    #
    # @example
    #   save range: 1..8, dir: '_pnp', prefix: 'bw_'
    #
    # Options support Arrays, see {file:README.md#Arrays_and_Singleton_Expansion Arrays and Singleon Expansion}
    #
    # @option opts [Enumerable] range (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts [String] dir (_output) the directory for the output to be sent to. Will be created if it doesn't exist.
    # @option opts [String] prefix (card_) the prefix of the file name to be printed.
    # @option opts [String] count_format (%02d) the format string used for formatting the card count (e.g. padding zeros). Uses a Ruby format string (see the Ruby doc for Kernel::sprintf for specifics)
    # @option opts [Boolean, :clockwise, :counterclockwise] rotate (false) if true, the saved cards will be rotated 90 degrees clockwise. Or, rotate by the number of radians. Intended to rendering landscape instead of portrait.
    # @return [nil] Returns nothing
    # @api public
    def save_png(opts = {})
      range = Args::CardRange.new(opts[:range], deck_size: size)
      batch = Args::SaveBatch.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      @progress_bar.start("Saving PNGs to #{batch.dir}/#{batch.count_format}*", size) do |bar|
        range.each do |i|
          @cards[i].save_png(batch[i])
          bar.increment
        end
      end
    end

    # Renders a range of cards in a showcase as if they are sitting in 3D on a reflective surface
    # See {file:samples/showcase.rb} for full example
    #
    # @example
    #   showcase file: 'showcase_output.png', trim: 78, trim_radius: 32
    #
    # @option opts [Enumerable, :all] range (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts [Fixnum] trim (0) the margin around the card to trim before putting into the showcase
    # @option opts [Fixnum] trim_radius (38) the rounded rectangle radius around the card to trim before putting into the showcase
    # @option opts [Fixnum] margin (75) the margin around the entire showcase
    # @option opts [Fixnum] scale (0.8) percentage of original width of each (trimmed) card to scale to. Must be between 0.0 and 1.0, but starts looking bad around 0.6.
    # @option opts [Fixnum] offset (1.1) percentage of the scaled width of each card to shift each offset. e.g. 1.1 is a 10% shift, and 0.95 is overlapping by 5%
    # @option opts [String, Color] fill_color (:white) backdrop color. Usually black or white. Supports gradients.
    # @option opts [Fixnum] reflect_offset (15) the number of pixels between the bottom of the card and the reflection. Supports Unit Conversion, see {file:README.md#Units Units}.
    # @option opts [Fixnum] reflect_strength (0.2) the starting alpha transparency of the reflection (at the top of the card). Percentage between 0 and 1. Looks more realistic at low values since even shiny surfaces lose a lot of light.
    # @option opts [Fixnum] reflect_percent (0.25) the length of the reflection in percentage of the card. Larger values tend to make the reflection draw just as much attention as the card, which is not good.
    # @option opts [:left, :right] face (:left) which direction the cards face. Anything but `:right` will face left
    # @option opts [String] dir (_output) the directory for the output to be sent to. Will be created if it doesn't exist.
    # @option opts [String] file ('showcase.png') the file to save in dir. Will be overwritten.
    # @return [nil] Returns nothing.
    # @api public
    def showcase(opts = {})
      range    = Args::CardRange.new(opts[:range], deck_size: size)
      showcase = Args::ShowcaseSpecial.new.load!(opts, expand_by: size, layout: layout, dpi: dpi)
      sheet    = Args::Sheet.new(custom_colors, {file: 'showcase.png'}).load!(opts, expand_by: size, layout: layout, dpi: dpi)
      render_showcase(range, sheet, showcase)
    end

    # Renders a range of cards fanned out as if in a hand. Saves as PNG.
    # See {file:samples/hand.rb} for full example
    #
    # @example
    #   hand range: :all, radius: :auto, margin: 20, fill_color: :white,
    #        angle_range: (Math::PI / -4.0)..(Math::PI / 2),
    #        dir: '_output', file: 'hand1.png'
    #
    # @option opts [Enumerable, :all] range (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts [Fixnum] radius (:auto) the distance from the bottom of each card to the center of the fan. If set to `:auto`, then it is computed as 30% of the card's height.
    # @option opts [Range] angle_range: ((Math::PI / -4.0)..(Math::PI / 2)). The overall width of the fan, in radians. Angle of zero is a vertical card. Further negative angles widen the fan counter-clockwise and positive angles widen the fan clockwise.
    # @option opts [Fixnum] trim (0) the margin around the card to trim before putting into the image
    # @option opts [Fixnum] trim_radius (0) the rounded rectangle radius around the card to trim before putting into the showcase
    # @option opts [Fixnum] margin (75) the margin around the entire image
    # @option opts [String, Color] fill_color (:white) backdrop color. Usually black or white. Supports gradients.
    # @option opts [String] dir (_output) the directory for the output to be sent to. Will be created if it doesn't exist.
    # @option opts [String] file ('hand.png') the file to save in dir. Will be overwritten.
    # @return [nil] Returns nothing.
    # @api public
    def hand(opts = {})
      opts = {file: 'hand.png', fill_color: :white, radius: :auto, trim_radius: 0}
             .merge(opts)
      opts = needs(opts,[:range, :margin, :trim, :trim_radius, :creatable_dir, :file_to_save])
      opts[:radius] = 0.3 * height if opts[:radius] == :auto
      render_hand(opts[:range], opts[:radius], opts[:angle_range],
                  opts[:trim], opts[:trim_radius], opts[:margin],
                  opts[:fill_color], opts[:dir], opts[:file])
    end

  end
end
