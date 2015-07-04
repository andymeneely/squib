require 'squib'

Squib::Deck.new(cards: 2) do
  background color: :white
  # If you really need something custom-made, the underlying cairo context
  # can be accessed directly via each Squib::Card
  #
  # WARNING! Input validation is not done on Squib::Cards. Proceed at your own risk.

  # The recommended approach is to use Deck's Enumerable, which iterates over Squib::Cards
  # I also recommend wrapping it in a Cairo save/restore, which Squib calls "use_cairo"
  each do |card|
    card.use_cairo do |cairo_context|
      cairo_context.set_source_color(:blue)
      cairo_context.circle(150, 150, 150)
      cairo_context.fill
    end
  end

  # Or the square bracket accessors []
  self[1].use_cairo do |cairo_context|
    cairo_context.circle(50, 50, 50)
    cairo_context.set_source_color(:red)
    cairo_context.fill
  end

  save_png prefix: 'cairo_access_'
end
