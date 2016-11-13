require 'squib'

Squib::Deck.new(width: 75, height: 75, cards: 2) do
  # puts "Groups enabled by environment: #{groups.to_a}"

  text str: ['A', 'B']

  build :print_n_play do
    rect
    save_sheet dir: '.', prefix: 'build_groups_bw_'
  end

  build :color do
    rect stroke_color: :red, dash: '5 5'
    save_png dir: '.', prefix: 'build_groups_color_'
  end

  build :test do
    save_png range: 0, dir: '.', prefix: 'build_groups_'
  end

end

# Here's how you can run this on the command line:
#
# --- OSX/Linux (bash or similar shells) ---
# $ ruby build_groups.rb
# $ SQUIB_BUILD=color ruby build_groups.rb
# $ SQUIB_BUILD=print_n_play,test ruby build_groups.rb
#
# --- Windows CMD ---
# $ ruby build_groups.rb
# $ set SQUIB_BUILD=color && ruby build_groups.rb
# $ set SQUIB_BUILD=print_n_play,test && ruby build_groups.rb
#
# Or, better yet... use a Rakefile like the one provided in this gist!
