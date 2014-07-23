#!/usr/bin/env ruby
require 'squib'

Squib::Deck.new(width: 825, height: 1125, cards: 3) do
  background color: :white

  # Takes the first sheet by default
  # Outputs a hash of arrays with the header names as keys
  data = xlsx file: 'sample.xlsx'

  text str: data['Name'], x: 250, y: 55, font: 'Arial 54'
  text str: data['Level'], x: 65, y: 65, font: 'Arial 72'
  text str: data['Description'], x: 65, y: 600, font: 'Arial 36'

  # You can also specify the sheet, starting at 0
  data = xlsx file: 'sample.xlsx', sheet: 2

  save format: :png, prefix: 'sample_excel_'
end
