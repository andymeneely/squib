require 'csv'
require 'fileutils'
require 'yaml'

DPI = 300

script_file = File.open('thegamecrafter.rb', 'w')
script_file.write("#!/usr/bin/env ruby\nrequire 'squib'\n")

CSV.foreach("tgc_printed_components.csv",{headers: true}) do |row|
  folder = row['Folder'].downcase
  shortname = row['Short Name'].downcase
  filename = shortname.tr(' ','_') + '.yml'
  FileUtils.mkdir_p folder.tr(' ','_')
  layout_file = File.open(folder.tr(' ','_') + '/' + filename, 'w')

  script_file.write(<<~END)
    Squib::Deck.new(
      layout: '#{folder.tr(' ','_')}/#{filename}'
    ) do
      background color: :white
      draw_layouts
      save_png dir: 'template_images', prefix: '#{folder.tr(' /','_')}_#{shortname.tr(' ','_')}_'
    end
  END

  incomplete_warning = "# WARNING: the code to write this file is not yet complete\n"
  layout_file.write(<<~END)
    # Layout for TheGameCrafter.com printed item: #{row['Printed Item']}
    # Image size is #{row['Image width (px)']}x#{row['Image height (px)']}px
    #
  END
  layouts = {}
  layouts['deck'] = {
    'dpi' => DPI,
    'width' => row['Image width (px)'].to_i,
    'height' => row['Image height (px)'].to_i,
    'stroke_width' => [[row['Image width (px)'].to_i,row['Image height (px)'].to_i].min/500,2].max,
  }
  layouts['template-cut-outline'] = {
    'extends' => "deck",
    'dash' => "5 5",
    'stroke_color' => :red,
  }
  layouts['template-safe-outline'] = {
    'extends' => "deck",
    'dash' => "5 5",
    'stroke_color' => :blue,
  }

  case folder
    when 'board', 'board/folding', 'booklet', 'deck', 'mat', 'misc',
      'punchout/small', 'punchout/medium', 'punchout/large', 'score pad', 'shard'
      case shortname
        when 'flower', 'invader', 'arrow chit', 'bullseye chit', 'large standee',
          'medium standee', 'medium triangle chit', 'small standee', 'triangle tile', 'tombstone'
          layout_file.write(incomplete_warning)
        when /hex/
          # hexagonal components
          layouts['template-cut-outline'].merge! ({
            'type' => "polygon",
            'n' => 6,
            'x' => "#{row['Image width (px)'].to_f/2/DPI}in",
            'y' => "#{row['Image height (px)'].to_f/2/DPI}in",
            'radius' => "#{row['Image width (px)'].to_f/2/DPI-row['X cut margin (in)'].to_f}in",
          })
          layouts['template-safe-outline'].merge! ({
            'type' => "polygon",
            'n' => 6,
            'x' => "#{row['Image width (px)'].to_f/2/DPI}in",
            'y' => "#{row['Image height (px)'].to_f/2/DPI}in",
            'radius' => "#{row['Image width (px)'].to_f/2/DPI-row['X cut margin (in)'].to_f*2/Math.sin(Math::PI/3)}in",
          })
        when 'spinner', 'large circle chit', 'medium circle chit', 'small circle chit',
          'large ring', 'medium ring', 'small ring', 'mini circle tile', 'circle'
          # circular components
          layouts['template-cut-outline'].merge! ({
            'type' => "circle",
            'x' => "#{row['Image width (px)'].to_f/2/DPI}in",
            'y' => "#{row['Image height (px)'].to_f/2/DPI}in",
            'radius' => "#{row['Image width (px)'].to_f/2/DPI-row['X cut margin (in)'].to_f}in",
          })
          case shortname
            when / ring$/
              # annular rings
              layouts['template-cut-interior'] = layouts['template-cut-outline'].clone
              layouts['template-cut-interior']['radius'] = "#{row['Image width (px)'].to_f/2-row['X cut margin (in)'].to_f-0.25}in"
            else 
              # whole circles
              layouts['template-safe-outline'].merge! ({
                'type' => "circle",
                'x' => "#{row['Image width (px)'].to_f/2/DPI}in",
                'y' => "#{row['Image height (px)'].to_f/2/DPI}in",
                'radius' => "#{row['Image width (px)'].to_f/2/DPI-row['X cut margin (in)'].to_f*2}in",
              })
              if shortname == 'spinner'
                RIVET_RADIUS = 0.155 #FIXME confirm this
                layouts['template-cut-rivethole'] = layouts['template-cut-outline'].clone
                layouts['template-cut-rivethole']['radius'] = "#{RIVET_RADIUS}in"
                layouts['template-safe-rivethole'] = layouts['template-safe-outline'].clone
                layouts['template-safe-rivethole']['radius'] = "#{RIVET_RADIUS+row['X cut margin (in)'].to_f}in"
              end
          end
        else
          # rectangular components
          layouts['template-cut-outline'].merge! ({
            'type' => "rect",
            'x' => "#{row['X cut margin (in)']}in",
            'y' => "#{row['Y cut margin (in)']}in",
            'width' => "-=#{row['X cut margin (in)'].to_f*2}in",
            'height' => "-=#{row['Y cut margin (in)'].to_f*2}in",
          })
          layouts['template-safe-outline'].merge! ({
            'type' => "rect",
            'x' => "#{row['X cut margin (in)'].to_f*2}in",
            'y' => "#{row['Y cut margin (in)'].to_f*2+(folder=='score pad' ? 0.25 : 0)}in",
            'width' => "-=#{row['X cut margin (in)'].to_f*4}in",
            'height' => "-=#{row['Y cut margin (in)'].to_f*4-(folder=='score pad' ? 0.25 : 0)}in",
            # score pad has a gap at the top for staples
          })
          if folder == 'deck'
            # rounded corners
            layouts['template-cut-outline']['radius'] = "0.125in"
            layouts['template-safe-outline']['radius'] = "0.125in"
          end
      end
    when 'box'
      layout_file.write(incomplete_warning)
    when 'dial'
      layout_file.write(incomplete_warning)
    when 'screen'
      layout_file.write(incomplete_warning)
    when 'sticker'
      layout_file.write(incomplete_warning)
    else
      puts "Encountered unknown component #{row['Printed Item']}"
  end
  layout_file.write(layouts.to_yaml.to_s.lines[1..-1].join)
end