require 'squib'

data = { 'name' => ['Thief', 'Grifter', 'Mastermind'],
        'type' => ['Thug', 'Thinker', 'Thinker'],
        'level' => [1, 2, 3] }

Squib::Deck.new(width: 825, height: 1125, cards: 3) do
  # Default range is :all
  background color: :white
  text str: data['name'], x: 250, y: 55, font: 'Arial 54'
  text str: data['level'], x: 65, y: 40, font: 'Arial 72'

  # Could be explicit about using :all, too
  text range: :all,
       str: data['type'], x: 40, y: 128, font: 'Arial 18',
       width: 100, align: :center

  # Ranges are inclusive, zero-based
  text range: 0..1, str: 'Thief and Grifter only!!', x: 25, y:200

  # Integers are also allowed
  text range: 0, str: 'Thief only!', x: 25, y: 250

  # Negatives go from the back of the deck
  text range: -1, str: 'Mastermind only!', x: 25, y: 250
  text range: -2..-1, str: 'Grifter and Mastermind only!', x: 25, y: 650

  # We can use Arrays too!
  text range: [0, 2], str: 'Thief and Mastermind only!!', x: 25, y:300

  # Just about everything in Squib can be given an array that
  # corresponds to the deck's cards. This allows for each card to be styled differently
  # This renders three cards, with three strings that had three different colors at three different locations.
  text str: %w(red green blue),
       color: [:red, :green, :blue],
       x: [40, 80, 120],
       y: [700, 750, 800]

  # Useful idiom: construct a hash from card names back to its index (ID),
  # then use a range. No need to memorize IDs, and you can add cards easily
  id = {} ; data['name'].each_with_index{ |name, i| id[name] = i}
  text range: id['Thief']..id['Grifter'],
       str: 'Thief through Grifter with id lookup!!',
       x:25, y: 400

  # Useful idiom: generate arrays from a column called 'type'
  type = {}; data['type'].each_with_index{ |t, i| (type[t] ||= []) << i}
  text range: type['Thinker'],
       str: 'Only for Thinkers!',
       x:25, y: 500

  # Useful idiom: draw a different number of images for different cards
  hearts = [nil, 1, 2] # i.e. card 0 has no hearts, card 2 has 2 hearts drawn
  1.upto(2).each do |n|
    range = hearts.each_index.select { |i| hearts[i] == n}
    n.times do |i|
      svg file: 'glass-heart.svg', range: range,
          x: 150, y: 55 + i * 42, width: 40, height: 40
    end
  end

  rect color: 'black' # just a border
  save_sheet prefix: 'ranges_', columns: 3
end
