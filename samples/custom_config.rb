require 'squib'

Squib::Deck.new(config: 'custom-config.yml') do
  # Custom color defined in our config
  background color: :foo

  # Hints can be turned on in the config file
  text str: 'The Title', x: 0, y: 78, width: 825,
       font: 'Arial 72', align: :center

  # Progress bars are shown for these commands
  # And images are taken from img_dir, not the cwd.
  png file: 'shiny-purse2.png', x: 620, y: 75
  svg file: 'spanner2.svg', x: 620, y: 218
  save_png prefix: 'custom-config_'
  save_pdf file: 'custom-config-out.pdf'

end
