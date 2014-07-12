require 'squib/commands/text_cmd'

class Squib
  attr_accessor :the_deck
  
end

##################
### PUBLIC API ###
##################

def deck(width:, height:, cards: 1)
  Squib.the_deck = Deck.new(width, height, cards)
end

def font(type: , size: 12, **options)
  Font.new()
end

def set_font(type: 'Arial', size: 12, **options)
	Squib::queue_command Squib::Commands::SetFont.new(type,size,options)
end

def text(range=:all, str: , font: :use_set, x: 0, y: 0, **options)
  range = 0..cards-1 if range == :all
  str = [str] * cards unless str.respond_to? :each
  #TODO define a singleton or something for the deck we're working on.
  str.each{ |s| Squib::Graphics::Text.new(card, s, font, x, y, options) }
  end
end

def image(range=:all, file: , x: 0, y: 0)
end

def load_csv(file:, header: true)
end

def data(field)
end

def render
  vv = VerifyVisitor.new
  CMDS.each do |cmd|
    cmd.accept(vv)
  end  
end