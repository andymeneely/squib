#!/usr/bin/env ruby
require 'squib'

Squib::Deck.new(config: 'custom-config.yml') do
	
  # Hints are turned on in the config file
  text str: "The Title", x: 0, y: 78, width: 825,
       font: 'Arial 72', align: :center

  # Progress bars are shown for these commands
  png file: 'shiny-purse.png', x: 620, y: 75
  svg file: 'spanner.svg', x: 620, y: 218
  save_png prefix: 'custom-config_'
  save_pdf file: "custom-config-out.pdf"

end