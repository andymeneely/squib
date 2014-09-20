#!/usr/bin/env ruby
require 'squib'

data = {'name' => ['Thief', 'Grifter', 'Mastermind'], 
        'level' => [1,2,3]}
longtext = "This is left-justified text.\nWhat do you know about tweetle beetles? well... \nWhen tweetle beetles fight, it's called a tweetle beetle battle. And when they battle in a puddle, it's a tweetle beetle puddle battle. AND when tweetle beetles battle with paddles in a puddle, they call it a tweetle beetle puddle paddle battle. AND... When beetles battle beetles in a puddle paddle battle and the beetle battle puddle is a puddle in a bottle... ..they call this a tweetle beetle bottle puddle paddle battle muddle. AND... When beetles fight these battles in a bottle with their paddles and the bottle's on a poodle and the poodle's eating noodles... ...they call this a muddle puddle tweetle poodle beetle noodle bottle paddle battle."

Squib::Deck.new(width: 825, height: 1125, cards: 3) do
  background color: :white
  rect x: 15, y: 15, width: 795, height: 1095, x_radius: 50, y_radius: 50
  rect x: 30, y: 30, width: 128, height: 128, x_radius: 25, y_radius: 25

  # Arrays are rendered over each card
  text str: data['name'], x: 250, y: 55, font: 'Arial weight=900 54'
  text str: data['level'], x: 65, y: 40, font: 'Arial 72', color: :burnt_orange

  text str: "UTF-8 \u2663", x: 565, y: 150, font: 'Arial weight=900 36'

  text str: "Font strings are expressive!", x:65, y: 200,
       font: 'Impact bold italic 36'

  text str: "Font strings are expressive!", x:65, y: 300,
       font: 'Arial,Verdana weight=900 style=oblique 36'

  text str: "Font string sizes can be overridden per card.", x: 65, y: 350,
       font: 'Impact 36', font_size: [16, 20, 24]

  text str: "This text has fixed width, fixed height, center-aligned, middle-valigned, and has a red hint", 
       hint: :red,
       x: 65, y: 400,
       width: 300, height: 200,
       align: :center, valign: :middle,
       font: 'Arial 18'

  text str: "Ellipsization!\nThe ultimate question of life, the universe, and everything to life and everything is 42",
       hint: :green, font: 'Arial 22',
       x: 450, y: 400,
       width: 280, height: 180,
       ellipsize: true

  hint text: :cyan
  text str: "Text hints are also globally togglable!",
        x: 65, y: 625,
        font: 'Arial 22'
  hint text: :off
  text str: "See? No hint here.",
        x: 565, y: 625,
        font: 'Arial 22'

  text str: longtext, font: 'Arial 16',
       x: 65, y: 700, 
       width: inches(2.25), height: inches(1), 
       justify: true

  text str: "<b>Markup</b> is also <i>quite</i> <s>easy</s> awesome", 
       markup: true,
       x: 50, y: 1000,
       width: 750, height: 100, 
       valign: :bottom,
       font: 'Arial 32', hint: :cyan
  
  save prefix: 'text_', format: :png
end
