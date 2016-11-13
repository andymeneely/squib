require 'squib'

# Showcases are a neat way to show off your cards in a modern way, using a
# reflection and a persepctive effect to make them look 3D
Squib::Deck.new(cards: 4) do
  background color: '#CE534D'
  rect fill_color: '#DED4B9', x: 78, y: 78,
       width: '2.25in', height: '3.25in', radius: 32
  text str: %w(Grifter Thief Thug Kingpin),
       font: 'Helvetica,Sans weight=800 120',
       x: 78, y: 78, width: '2.25in', align: :center
  svg file: 'spanner.svg', x: (825 - 500) / 2, y: 500, width: 500, height: 500

  # Defaults are pretty sensible.
  showcase file: 'showcase.png'

  # Here's a more complete example.
  # Tons of ways to tweak it if you like - check the docs.
  showcase trim: 32, trim_radius: 32, margin: 100, face: :right,
           scale: 0.85, offset: 0.95, fill_color: :black,
           reflect_offset: 25, reflect_strength: 0.1, reflect_percent: 0.4,
           file: 'showcase2.png'

  save_png prefix: 'showcase_individual_' # to show that they're not trimmed
end
