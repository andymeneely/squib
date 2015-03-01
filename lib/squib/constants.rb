module Squib
    # Squib's defaults for when arguments are not specified in the command nor layouts.
    #
    # @api public
    SYSTEM_DEFAULTS = {
      :align => :left,
      :alpha => 1.0,
      :angle => 0,
      :blend => :none,
      :color => :black,
      :columns => 1,
      :count_format => '%02d',
      :default_font => 'Arial 36',
      :dir => '_output',
      :ellipsize => :end,
      :face => :left,
      :fill_color => '#0000',
      :force_id => false,
      :font => :use_set,
      :font_size => nil,
      :format => :png,
      :gap => 0,
      :height => :native,
      :hint => :off,
      :img_dir => '.',
      :justify => false,
      :margin => 75,
      :markup => false,
      :mask => nil,
      :offset => 1.1,
      :prefix => 'card_',
      :progress_bar => false,
      :reflect_offset => 15,
      :reflect_percent => 0.25,
      :reflect_strength => 0.2,
      :range => :all,
      :rotate => false,
      :rows => :infinite,
      :scale => 0.85,
      :sheet => 0,
      :spacing => 0,
      :str => '',
      :stroke_color => :black,
      :stroke_width => 2.0,
      :trim => 0,
      :trim_radius => 38,
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
      'antialias'     => 'best',
      'backend'       => 'memory',
      'count_format'  => SYSTEM_DEFAULTS[:count_format],
      'custom_colors' => {},
      'dir'           => SYSTEM_DEFAULTS[:dir],
      'dpi'           => 300,
      'hint'          => :none,
      'img_dir'       => '.',
      'progress_bar'  => false,
    }

    # These are parameters that are intended to be "expanded" across
    # range if they are singletons.
    #
    # For example: using a different font for each card, using one `text` command
    #
    # key: the internal name of the param (e.g. :files)
    # value: the user-facing API key (e.g. file: 'abc.png')
    #
    # @api private
    EXPANDING_PARAMS = {
          :align => :align,
          :alpha => :alpha,
          :angle => :angle,
          :blend => :blend,
          :circle_radius => :radius,
          :color => :color,
          :ellipsize => :ellipsize,
          :files => :file,
          :fill_color => :fill_color,
          :force_svgid => :force_id,
          :font => :font,
          :font_size => :font_size,
          :height => :height,
          :hint => :hint,
          :justify => :justify,
          :layout => :layout,
          :markup => :markup,
          :mask => :mask,
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
          :y3 => :y3,
          :y_radius => :y_radius,
      }

    # These parameters are considered for unit conversion
    #
    # For example
    #    text str: 'Hello, World', x: '1in'
    #
    # key: the internal name of the param (e.g. :circle_radius)
    # value: the user-facing API key (e.g. radius: '1in')
    UNIT_CONVERSION_PARAMS = {
      :circle_radius => :radius,
      :gap => :gap,
      :height => :height,
      :margin => :margin,
      :paper_width => :width,
      :paper_height => :height,
      :rect_radius => :radius,
      :spacing => :spacing,
      :stroke_width => :stroke_width,
      :trim => :trim,
      :width => :width,
      :x => :x,
      :x1 => :x1,
      :x2 => :x2,
      :x3 => :x3,
      :x_radius => :x_radius,
      :y => :y,
      :y1 => :y1,
      :y2 => :y2,
      :y3 => :y3,
      :y_radius => :y_radius,
    }

    # Used for inch-cm conversion
    # :nodoc:
    # @api private
    INCHES_IN_CM = 0.393700787
end
