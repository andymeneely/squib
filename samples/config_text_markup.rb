require 'squib'

Squib::Deck.new(config: 'config_text_markup.yml') do
  background color: :white
  text str: %{"'Yaml ain't markup', he says"},
       x: 10, y: 10, width: 300, height: 200, font: 'Serif 20',
       markup: true, hint: :cyan

  text str: 'Notice also the antialiasing method.',
       x: 320, y: 10, width: 300, height: 200, font: 'Arial Bold 20'

  save_png prefix: 'config_text_'
end

Squib::Deck.new(config: 'config_disable_quotes.yml') do
  text str: %{This has typographic sugar --- and ``explicit'' quotes --- but the quotes are "dumb"},
       x: 10, y: 10, width: 300, height: 200, font: 'Serif 20',
       markup: true, hint: :cyan
  save_png prefix: 'config_disable_text_'
end
