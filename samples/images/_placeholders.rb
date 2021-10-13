# require 'squib'
require_relative '../../lib/squib'

# By default Squib will simply warn you if an image is missing
# Instead, you can give it a `placeholder`
Squib.configure img_missing: :silent  # no warnings, no errors, no placeholder
# Squib.configure img_missing: :warn  # default
# Squib.configure img_missing: :error # pre Squib v0.18 behavior... blech

Squib::Deck.new(width: 100, height: 100, cards: 3) do
  background color: :white

  files = %w(angler-fish.png does-not-exist.png) # last one is nil
  png file: files, placeholder: 'grit.png'
  save_sheet columns: 1, prefix: 'placeholder_sheet_'
end

# Placeholders can be per-image too.
# What if a placeholder is specified but doesn't exist? It'll always warn.
Squib.configure img_missing: :warn # default
Squib::Deck.new(width: 100, height: 100, cards: 4) do
  background color: :white

  files =        %w(angler-fish.png does-not-exist.png does-not-exist.png does-not-exist.png)
  placeholders = %w(grit.png        does-not-exist.png grit.png                             )
  png file: files, placeholder: placeholders

  # text embeds can have placeholders too
  text(str: 'A', color: :red) do |embed|
    embed.png key: 'A', file: files, placeholder: placeholders, width: 30, height: 30
  end

  save_sheet columns: 1, prefix: 'multi_placeholder_sheet_'
end

# Do errors work?
# If you REALLY want the old, pre-Squib v0.18 functionality
# ...you can still have it
# This is really more of a regression test than example.
Squib.configure img_missing: :error
Squib::Deck.new(width: 100, height: 100, cards: 1) do
  begin
    png file: 'does-not-exist.png' # no placeholder... should error!
    raise Exception.new 'Runtime Error should have been thrown!'
  rescue RuntimeError => e
    # a runtime error should have happened here. So nothing happens. Good.
    Squib.logger.error 'Yay! An error we expected was thrown.'
  end
end