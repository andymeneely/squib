module Squib
  class Card

    def save_png(i, dir, prefix)
      cairo_context.target.write_to_png("#{dir}/#{prefix}#{i}.png")
    end

  end
end