module Squib::Args::ColorValidator

  def colorify(color, custom_colors = {})
    custom_colors[color.to_s] || color.to_s
  end

end
