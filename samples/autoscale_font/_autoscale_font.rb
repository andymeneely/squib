require 'squib'

# Autoscaling font is handy for a bunch of things:
#  * Picture-perfect text fitting for one-off
#  * Rapid prototyping where you don't have to think about sizes
#
# We've got three options...
#  Option 1. Use your data <--- good for picture-perfect
#  Option 2. Use ellipsize: :autoscale <--- good for rapid prototyping
#  Option 3. Use map ranges in your code <--- good for picture-perfect
#                                             or other weird cases

###########################
# Option 1: Use your data #
###########################
# If you want to tweak the font size per-card, you can always make font_size
# a column and map it from there. This is tedious but leads to perfectly
# customized results
my_data = Squib.csv data: <<~CSV
  "Title","Font Size"
  "Short & Big",10
  "Medium Length & Size", 5
  "Super duper long string here, therefore a smaller font.", 4
CSV

Squib::Deck.new(width: 300, height: 75, cards: 3) do
  background color: :white
  rect stroke_color: :black

  text str: my_data.title, font: 'Arial',
       font_size: my_data.font_size, # <-- key part
       x: 10, y:10, align: :center,
       width: 280, # <-- note how height does NOT need to be set
       ellipsize: false,
       hint: :red
  save_sheet columns: 3, prefix: 'autoscale_w_data_'
end

#######################################
# Option 2: Use ellipsize: :autoscale #
#######################################
# If set the height, you can set "autoscale" and it will incrementally
# downgrade the font size until the text does not ellipsize
#
# Great for rapid prototyping, set-it-and-forget-it
#
# NOTE: You MUST set the height for this to work. Otherwise, the text will
#       never ellipsize and Squib doesn't know when to start autoscaling
Squib::Deck.new(width: 300, height: 75, cards: 3) do
  background color: :white
  rect stroke_color: :black
  title = ['Short & Big',
           'Medium Length & Size',
           'Super duper long string here, therefore a smaller font.']

  # Automatically scale the text down from the specified font_size to the largest size that fits
  text str: title, font: 'Arial',
       font_size: 15, # <-- this is the MAX font size. Scale down from here
       ellipsize: :autoscale, # <-- key part
       height: 50, # <-- need this to be set to something
       width: 280, x: 10, y: 10, align: :center, valign: :middle, hint: :red

  save_sheet columns: 3, prefix: 'autoscale_w_ellipsize_'
end

############################################
# Option 3: Mapping to ranges in your code #
############################################
# Here's an in-between option that allows you to programmatically apply font
# sizes. This allows you a ton of flexibility.Probably more flexibility than
# you need, frankly. But one advantage is that you don't have to set the height
def autoscale(str_array)
  str_array.map do | str |
    case str.length
    when 0..15
      9
    when 16..20
      6
    else
      4
    end
  end
end

Squib::Deck.new(width: 300, height: 75, cards: 3) do
  background color: :white
  rect stroke_color: :black
  title = ['Short & Big',
           'Medium Length & Size',
           'Super duper long string here, therefore a smaller font.']

  # Scale text based on the string length
  text str: title, font: 'Arial',
       font_size: autoscale(title), # <-- key part
       x: 10, y:10, align: :center, width: 280, ellipsize: false, hint: :red

    save_sheet columns: 3, prefix: 'autoscale_w_range_'
end
