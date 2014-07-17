#!/usr/bin/env ruby
require 'squib'

data = {'name' => ['Thief', 'Grifter', 'Mastermind'], 
        'level' => [1,2,3]}
longtext = "Hello, World! What do you know about tweetle beetles? well... \nWhen tweetle beetles fight, it's called a tweetle beetle battle. And when they battle in a puddle, it's a tweetle beetle puddle battle. AND when tweetle beetles battle with paddles in a puddle, they call it a tweetle beetle puddle paddle battle. AND... When beetles battle beetles in a puddle paddle battle and the beetle battle puddle is a puddle in a bottle... ..they call this a tweetle beetle bottle puddle paddle battle muddle. AND... When beetles fight these battles in a bottle with their paddles and the bottle's on a poodle and the poodle's eating noodles... ...they call this a muddle puddle tweetle poodle beetle noodle bottle paddle battle."

Squib::Deck.new(width: 825, height: 1125, cards: 3) do
  background color: [1.0,1.0,1.0]
  rect x: 15, y: 15, width: 795, height: 1095, x_radius: 50, y_radius: 50
  rect x: 30, y: 30, width: 128, height: 128, x_radius: 25, y_radius: 25

  text str: data['name'], x: 250, y: 55, font: 'Arial 54'
  text str: data['level'], x: 65, y: 40, font: 'Arial 72'
  text str: longtext, x: 100, y: 600, font: 'Arial 16'

  png file: 'shiny-purse.png', x: 665, y: 30

  save format: :png
end

puts "Done!"