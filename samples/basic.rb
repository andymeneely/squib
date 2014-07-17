#!/usr/bin/env ruby
require 'squib'

data = {'name' => ['Thief', 'Grifter', 'Mastermind'], 
        'level' => [1,2,3]}

Squib::Deck.new(width: 825, height: 1125, cards: 3) do
  background color: :white
  rect x: 15, y: 15, width: 795, height: 1095, x_radius: 50, y_radius: 50
  rect x: 30, y: 30, width: 128, height: 128, x_radius: 25, y_radius: 25

  text str: data['name'], x: 250, y: 55, font: 'Arial 54'
  text str: data['level'], x: 65, y: 40, font: 'Arial 72'

  png range: [0,2], file: 'shiny-purse.png', x: 665, y: 30
  svg range: 1..2, file: 'spanner.svg', x: 665, y: 165

  save format: :png
end

puts "Done!"