module Squib
  class Deck

    # Toggle hints globally. 
    #
    # Text hints are rectangles around where the text will be laid out. They are intended to be temporary.
    # Setting a hint to nil or to :off will disable hints. @see samples/text.rb
    # @example
    #   hint text: :cyan
    #   hint text: :cyan
    #
    # @param [String] text the color of the text hint. To turn off use :off. @see README.md 
    # @return [nil] Returns nothing
    # @api public
    def hint(text: :off)
      @text_hint = text
    end

    # Sets various defaults for this deck. Defaults can be overriden by the commands themselves when that command supports it.
    # @example 
    #   set font: 'Arial 26'
    #   text 'blah'                     # in Arial 26
    #   text 'blah24', font: 'Arial 24' # in Arial 24
    #   set font: :default              # Back to Squib-wide default
    #
    # @option opts font: the font string to set as default. Can also be set to `:default` to use the Squib-wide default.
    # @option opts img_dir: the default directory to READ images from. Default is `.`. Useful for switching from bw to color images.
    # @return [nil] Returns nothing
    # @api public
    def set(opts = {})
      opts = needs(opts, [:font, :img_dir])
      @font = opts[:font][0] #was expanded - just need the first
      @img_dir = opts[:img_dir]
    end 

  end
end
