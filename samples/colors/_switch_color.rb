require 'squib'

# Choose between black and white color theme for type snake
#   * Allow using white snake cards with black text or
#     black snake cards with white text
color = 'white'

cards = Squib.csv file: '_switch_color_data.csv', col_sep: "\t"

Squib::Deck.new cards: cards['Type'].size do

    background_color = cards['Type'].map do |t|
        if color == 'black' && t == "Snake" then
            "black"
        else
            "white"
        end
    end
    background color: background_color

    text_color = cards['Type'].map do |t|
        if color == 'black' && t == "Snake" then
            "white"
        else
            "black"
        end
    end

    text str: cards['Text'], color: text_color

    save_png prefix: '_switch_color_sample_'

end
