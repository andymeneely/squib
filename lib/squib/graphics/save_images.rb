module Squib
  class Card

    def save_png(i, dir: '_img')
      cairo_context.target.write_to_png("#{dir}/img_#{i}.png")
    end

  end
end