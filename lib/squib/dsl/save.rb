require 'rainbow/refinement'
require_relative 'save_png'
require_relative 'save_pdf'

module Squib
  class Deck
    using Rainbow # we can colorize strings now!
    def save(opts = {})
      fmts = Array(opts[:format])
      warn 'Must specify format :png and/or :pdf' if fmts.empty?
      opts.delete :format # not needed anymore
      save_png(opts) if fmts.include? :png
      save_pdf(opts) if fmts.include? :pdf
      uns = fmts - [:pdf, :png ]
      unless uns.empty?
        warn "Unsupported format(s) #{uns} to #{'save'.cyan}()", uplevel: 1
      end
      self
    end
  end
end
