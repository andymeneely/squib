module Squib
    
    #@api public
    SYSTEM_DEFAULTS = { 
   		:range => :all,
   		:color => :white,
      :str => '',
      :fill_color => '#0000',
      :stroke_color => :black,
   		:font => 'Arial, Sans 36',
   		:sheet => 0,
   		:x => 0,
   		:y => 0,
      :fitxy => false,
      :align => :left,
      :valign => :top,
      :justify => false,
      :ellipsize => :end,
      :width => :native,
      :height => :native,
   		:alpha => 1.0,
      :format => :png,
      :dir => "_output",
      :prefix => "card_"
    }

end