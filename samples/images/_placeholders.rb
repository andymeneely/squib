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
# What if a placeholder is specified but doesn't exist?
# It'll always warn.
Squib::Deck.new(width: 100, height: 100, cards: 3) do
  background color: :white

  files =        %w(angler-fish.png does-not-exist.png does-not-exist.png)
  placeholders = %w(grit.png        does-not-exist.png grit.png)
  png file: files, placeholder: placeholders
  save_sheet columns: 1, prefix: 'multi_placeholder_sheet_'
end