module Squib
    # Squib's defaults for when arguments are not specified in the command nor layouts.
    # 
    # @api public
    SYSTEM_DEFAULTS = { 
      :align => :left,
      :alpha => 1.0,
      :color => :black,
      :default_font => 'Arial 36',
      :dir => "_output",
      :ellipsize => :end,
      :fill_color => '#0000',
      :font => :use_set,
      :format => :png,
      :gap => 0,
      :height => :native,
      :justify => false,
      :margin => 75,
      :markup => false,
      :prefix => "card_",
      :progress_bar => false,
      :range => :all,
      :sheet => 0,
      :spacing => 0,
      :str => '',
      :stroke_color => :black,
      :stroke_width => 2.0,
      :trim => 0,
      :valign => :top,
      :width => :native,
      :wrap => true,
      :x => 0,
      :x1 => 100,
      :x2 => 150,
      :x3 => 100,
      :x_radius => 0, 
      :y => 0,
      :y1 => 100,
      :y2 => 150,
      :y3 => 150,
      :y_radius => 0,
    }

    # Squib's configuration defaults
    # 
    # @api public
    CONFIG_DEFAULTS = { 
      'custom_colors' => {},
      'dpi' => 300,
      'hint' => nil,
      'progress_bar' => false,
    }

    # These are parameters that are intended to be "expanded" across 
    # range if they are singletons. 
    #
    # For example, using a different font for each card, using one `text`
    #
    # key: the internal name of the param (e.g. :files)
    # value: the user-facing API key (e.g. file: 'abc.png')
    #
    # @api private
    EXPANDING_PARAMS = {
          :align => :align,
          :alpha => :alpha,
          :circle_radius => :radius,
          :color => :color,
          :ellipsize => :ellipsize,
          :files => :file,
          :fill_color => :fill_color,
          :font => :font,
          :height => :height,
          :hint => :hint,
          :justify => :justify,
          :layout => :layout,
          :markup => :markup,
          :rect_radius => :radius,
          :spacing => :spacing,
          :str => :str,
          :stroke_color => :stroke_color,
          :stroke_width => :stroke_width,
          :svgid => :id,
          :valign => :valign,
          :width => :width,
          :wrap => :wrap,
          :x => :x,
          :x1 => :x1,
          :x2 => :x2,
          :x3 => :x3,
          :x_radius => :x_radius,
          :y => :y,
          :y1 => :y1,
          :y2 => :y2,
          :y2 => :y3,
          :y_radius => :y_radius,
      }
end