require 'squib'
puts "Using Squib #{Squib::VERSION}"

Squib::Deck.new(cards: 3, dpi: 600) do
  background color: :gray
  text str: %w(Hello fine world!)
  save_pdf file: 'foo.pdf', gap: 5, width: '11in', height: '8.5in'
end