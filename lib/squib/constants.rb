module Squib
    # Squib's defaults for when arguments are not specified in the command nor layouts.
    # 
    # @api public
    SYSTEM_DEFAULTS = { 
      :range => :all,
      :color => :black,
      :str => '',
      :fill_color => '#0000',
      :stroke_color => :black,
      :stroke_width => 2.0,
      :font => :use_set,
      :default_font => 'Arial 36',
      :sheet => 0,
      :x => 0,
      :y => 0,
      :x1 => 100,
      :y1 => 100,
      :x2 => 150,
      :y2 => 150,
      :x3 => 100,
      :y3 => 150,
      :x_radius => 0, 
      :y_radius => 0,
      :align => :left,
      :valign => :top,
      :justify => false,
      :ellipsize => :end,
      :wrap => true,
      :width => :native,
      :height => :native,
      :spacing => 0,
      :alpha => 1.0,
      :format => :png,
      :dir => "_output",
      :prefix => "card_",
      :margin => 75,
      :gap => 0,
      :trim => 0,
      :progress_bar => false
    }

    # Squib's configuration defaults
    # 
    # @api public
    CONFIG_DEFAULTS = { 
      'dpi' => 300,
      'progress_bar' => false,
      'hint' => nil
    }

end