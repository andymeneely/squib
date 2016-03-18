require 'squib'

Squib::Deck.new(cards: 2) do
  background color: :white

  # Outputs a hash of arrays with the header names as keys
  data = csv file: 'sample.csv'
  text str: data['Type'], x: 250, y: 55, font: 'Arial 54'
  text str: data['Level'], x: 65, y: 65, font: 'Arial 72'

  save format: :png, prefix: 'sample_csv_'

  # You can also specify the sheet, starting at 0
  data = xlsx file: 'sample.xlsx', sheet: 2
end

# CSV is also a Squib-module-level function, so this also works:
data      = Squib.csv file: 'quantity_explosion.csv' # 2 rows...
num_cards = data['Name'].size                        #          ...but 4 cards!

Squib::Deck.new(cards: num_cards) do
  background color: :white
  rect # card border
  text str: data['Name'], font: 'Arial 54'
  save_sheet prefix: 'sample_csv_qty_', columns: 4
end

# Additionally, CSV supports inline data specifically
data = Squib.csv data: <<-EOCSV
Name,Cost
Knight,3
Orc,1
EOCSV
