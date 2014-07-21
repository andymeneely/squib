#!/usr/bin/env ruby
require 'squib'

data = {'name' => ['Thief', 'Grifter', 'Mastermind'], 
        'level' => [1,2,3]}

Squib::Deck.new(width: 825, height: 1125, cards: 3) do
  background color: :white
  rect x: 38, y: 38, width: 750, height: 1050, x_radius: 38, y_radius: 38
  rect x: 75, y: 75, width: 128, height: 128, x_radius: 25, y_radius: 25

  text str: data['name'], x: 220, y: 78, font: 'Arial 54'
  text str: data['level'], x: 75, y: 85, width: 128, 
       font: 'Arial 72', align: :center

  png range: [0,2], file: 'shiny-purse.png', x: 620, y: 75
  svg range: 1..2, file: 'spanner.svg', x: 620, y: 218

  save prefix: 'basic_', format: :png
end

puts "Done!"