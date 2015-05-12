module Squib
  class Deck

    # Saves the given range of cards to either PNG or PDF
    #
    # @option opts [Enumerable] range (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts [String] dir (_output) the directory for the output to be sent to. Will be created if it doesn't exist.
    # @option opts [Symbol] format (:png)  the format that this will be rendered too. Options `:pdf, :png`. Array of both is allowed: `[:pdf, :png]`
    # @option opts [String] prefix (card_) the prefix of the file name to be printed
    # @option opts [Boolean] rotate (false) PNG saving only. If true, the saved cards will be rotated 90 degrees clockwise. Intended to rendering landscape instead of portrait.
    # @return self
    # @api public
    def save(opts = {})
      # opts = needs(opts, [:range, :creatable_dir, :formats, :prefix, :rotate])
      save_png(opts) if Array(opts[:format]).include? :png
      save_pdf(opts) if Array(opts[:format]).include? :pdf
      self
    end

    # Saves the given range of cards to a PNG
    #
    # @example
    #   save range: 1..8, dir: '_pnp', prefix: 'bw_'
    #
    # @option opts [Enumerable] range (:all) the range of cards over which this will be rendered. See {file:README.md#Specifying_Ranges Specifying Ranges}
    # @option opts [String] dir (_output) the directory for the output to be sent to. Will be created if it doesn't exist.
    # @option opts [String] prefix (card_) the prefix of the file name to be printed.
    # @option opts [String] count_format (%02d) the format string used for formatting the card count (e.g. padding zeros). Uses a Ruby format string (see the Ruby doc for Kernel::sprintf for specifics)
    # @option opts [Boolean, :clockwise, :counterclockwise] rotate (false) if true, the saved cards will be rotated 90 degrees clockwise. Or, rotate by the number of radians. Intended to rendering landscape instead of portrait.
    # @return [nil] Returns nothing
    # @api public
    def save_png(opts = {})
      opts = needs(opts,[:range, :creatable_dir, :prefix, :count_format, :rotate])
      @progress_bar.start("Saving PNGs to #{opts[:dir]}/#{opts[:prefix]}*", @cards.size) do |bar|
        opts[:range].each do |i|
          @cards[i].save_png(i, opts[:dir], opts[:prefix], opts[:count_format], opts[:rotate], opts[:angle])
          bar.increment
        end
      end
    end

    # Renders a range of files in a showcase as if they are sitting on a reflective surface
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
    # @option opts [String, Color] fill_color (:white) backdrop color. Usually black or white.
    # @option opts [Fixnum] reflect_offset (15) the number of pixels between the bottom of the card and the reflection
    # @option opts [Fixnum] reflect_strength (0.2) the starting alpha transparency of the reflection (at the top of the card). Percentage between 0 and 1. Looks more realistic at low values since even shiny surfaces lose a lot of light.
    # @option opts [Fixnum] reflect_percent (0.25) the length of the reflection in percentage of the card. Larger values tend to make the reflection draw just as much attention as the card, which is not good.
    # @option opts [:left, :right] face (:left) which direction the cards face. Anything but `:right` will face left
    # @option opts [String] dir (_output) the directory for the output to be sent to. Will be created if it doesn't exist.
    # @option opts [String] file ('showcase.png') the file to save in dir. Will be overwritten.
    # @return [nil] Returns nothing.
    # @api public
    def showcase(opts = {})
      opts = {file: 'showcase.png', fill_color: :white}.merge(opts)
      opts = needs(opts,[:range, :margin, :trim, :trim_radius, :creatable_dir, :file_to_save, :face])
      render_showcase(opts[:range], opts[:trim], opts[:trim_radius],
                      opts[:scale], opts[:offset], opts[:fill_color],
                      opts[:reflect_offset], opts[:reflect_percent], opts[:reflect_strength],
                      opts[:margin], opts[:face],
                      opts[:dir], opts[:file])
    end

    
    def hand(opts = {})
      opts = {file: 'hand.png', fill_color: :white}.merge(opts)
      opts = needs(opts,[:range, :margin, :trim, :trim_radius, :creatable_dir, :file_to_save])
      render_hand()
    end

  end
end
