require 'squib/commands/text_cmd'
require 'squib/queue'


##################
### PUBLIC API ###
##################

def deck(width:, height:, cards: 1)
  Deck.new(width, height, cards)
end

def font(type: , size: 12, **options)
  Font.new()
end

def set_font(type: 'Arial', size: 12, **options)
	Squib::queue_command Squib::Commands::SetFont.new(type,size,options)
end

def text(range=:all, str: , font: :use_set, x: 0, y: 0, **options)
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