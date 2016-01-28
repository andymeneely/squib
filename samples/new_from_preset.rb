require 'squib'

Squib::Deck.new_from_preset card_name: "poker", vendor: "pnp_productions", cards: 3 do
  text str: ["these","are","cards"], x: 100, y:100
  ...
end

# Card size will be 2.5 inches by 3.5 inches, plus 0.2 cm bleed on each side.  This will make cards the right size for using with print and play productions poker card templates.
# We are working to improve the save_sheet functionality so that Squib can produce printer-ready files directly and on increasing support for more card sizes and vendor.
