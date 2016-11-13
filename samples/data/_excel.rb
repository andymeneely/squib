require 'squib'

Squib::Deck.new(cards: 3) do
  background color: :white

  # Reads the first sheet by default (sheet 0)
  # Outputs a hash of arrays with the header names as keys
  data = xlsx file: 'sample.xlsx'

  text str: data['Name'], x: 250, y: 55, font: 'Arial 54'
  text str: data['Level'], x: 65, y: 65, font: 'Arial 72'
  text str: data['Description'], x: 65, y: 600, font: 'Arial 36'

  save format: :png, prefix: 'sample_excel_' # save to individual pngs
end

# xlsx is also a Squib-module-level function, so this also works:
data      = Squib.xlsx file: 'explode_quantities.xlsx' # 2 rows...
num_cards = data['Name'].size                          #          ...but 4 cards!

Squib::Deck.new(cards: num_cards) do
  background color: :white
  rect # card border
  text str: data['Name'], font: 'Arial 54'
  save_sheet prefix: 'sample_xlsx_qty_', columns: 4
end


# Here's another example, a bit more realistic. Here's what's going on:
#   * We call xlsx from Squib directly - BEFORE Squib::Deck creation. This
#     allows us to infer the number of cards based on the size of the "Name"
#     field
#   * We make use of quantity explosion. Fields named "Qty" or "Quantity"
#     (any capitalization), or any other in the "qty_header" get expanded by the
#     number given
#   * We also make sure that trailing and leading whitespace is stripped
#     from each value. This is the default behavior in Squib, but the options
#     are here just to make sure.

resource_data = Squib.xlsx(file: 'sample.xlsx', sheet: 2, strip: true) do |header, value|
  case header
  when 'Cost'
    "$#{value}k" # e.g. "3" becomes "$3k"
  else
    value # always return the original value if you didn't do anything to it
  end
end

Squib::Deck.new(cards: resource_data['Name'].size) do
  background color: :white
  rect width: :deck, height: :deck
  text str: resource_data['Name'], align: :center, width: :deck, hint: 'red'
  text str: resource_data['Cost'], align: :right, width: :deck, hint: 'red'
  save_sheet prefix: 'sample_excel_resources_' # save to a whole sheet
end
