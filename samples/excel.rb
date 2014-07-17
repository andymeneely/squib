#!/usr/bin/env ruby
require 'squib'

Squib::Deck.new(width: 825, height: 1125, cards: 3) do
  background color: :white

  data = xlsx file: 'sample.xlsx', sheet: 0

  text str: data['Name'], x: 250, y: 55, font: 'Arial 54'
  text str: data['Level'], x: 65, y: 65, font: 'Arial 72'
  text str: data['Description'], x: 65, y: 600, font: 'Arial 36'

  save format: :png, prefix: 'sample_excel_'
end

puts "Done!"