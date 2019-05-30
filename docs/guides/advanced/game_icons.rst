Squib + Game-Icons.net
======================

I believe that, in prototyping, you want to focus on getting your idea to the table as fast as possible. Artwork is the kind of thing that can wait for later iterations once you know your game is a good one.

But! Playtesting with just text is a real drag.

Fortunately, there's this amazing project going on over at http://game-icons.net. They are in the process of building a massive library of gaming-related icons.

As a sister project to Squib, I've made a Ruby gem that interfaces with the Game Icons library. With this gem, you can access Game Icons files, and even manipulate them as they go into your game.

Here are some instructions for working with the Game Icons gem into Squib.

Install the Gem
---------------

To get the gem, do:

  $ gem install game_icons

The library update frequently, so it's a good idea to upgrade whenever you can.

  $ gem up game_icons

If you are using Bundler, go ahead and put this in your Gemfile::

  gem 'game_icons'

And then run ``bundle install`` to install it from there.

The ``game_icons`` gem has no required dependencies. However, if you want to manipulate the SVG

To begin using the gem, just require it::

  require 'game_icons'

Find Your Icon
--------------

Game-Icons.net has a search engine with some great tagging. Find the icon that you need. The gem will need the "name" of your icon. You can get this easily from the URL. For example:

  http://game-icons.net/lorc/originals/meat.html

could be called::

  'meat'
  :meat

Symbols are okay too (really, anything that responds to ``to_s`` will suffice). Spaces are replaced with a dash::

  'police-badge'
  :police_badge

However, some icons have the same name but different authors. To differentiate these, you put the author name before a slash. Like this::

  'lorc/meat'
  'andymeneely/police-badge'

To get the Icon, you use ``GameIcons#get``::

  GameIcons.get(:meat)
  GameIcons.get('lorc/meat')
  GameIcons.get(:police_badge)
  GameIcons.get('police-badge')
  GameIcons.get('andymeneely/police-badge')

If you want to know all the icon names, you can always use::

  GameIcons.names # returns the list of icon names

If you end up misspelling one, the gem will suggest one:

.. code-block:: shell

    irb(main):005:0> GameIcons.get(:police_badg)
    RuntimeError: game_icons: could not find icon 'police_badg'. Did you mean any of these? police-badge

Use the SVG File
----------------

If you just want to use the icon in your game, you can just use the ``file`` method::

  svg file: GameIcons.get(:police-badge).file

Recolor the SVG file
--------------------

The gem will also allow you to recolor the icon as you wish, setting foreground and background::

  # recolor foreground and background to different shades of gray
  svg data: GameIcons.get('glass-heart').
                      recolor(fg: '333', bg: 'ccc').
                      string

  # recolor with opacity
  svg data: GameIcons.get('glass-heart').
                      recolor(fg: '333', bg: 'ccc',
                              fg_opacity: 0.25, bg_opacity: 0.75).
                      string

Use the SVG XML Data
--------------------

SVGs are just XML files, and can be manipulated in their own clever ways. GameIcons is super-consistent in the way they format their SVGs - the entire icon is flattened into one path. So you can manipulate how the icon looks in your own way. Here's an example of using straight string substitution::

  svg data: GameIcons.get(:meat).string.gsub('fill="#fff"', 'fill="#abc"')

Here's a fun one. It replaces all non-white colors in your SVG with black through the SVG::

  svg data: GameIcons.get(:meat).string.gsub(':#ffffff', 'snarfblat').
                                        gsub(/:#[0-9a-f]{6}/, ':#000000').
                                        gsub('snarfblat', ':#ffffff')

XML can also be manipulated via CSS or XPATH queries via the ``nokogiri`` library, which Squib has as a dependency anyway. Like this::

  doc = Nokogiri::XML(GameIcons.get(:meat).string)
  doc.css('path')[1]['fill'] = #f00 # set foreground color to red
  svg data: doc.to_xml


Path Weirdness
--------------

Inkscape and Squib's libRSVG renderer can lead to unexpected results for some icons. This has to do with a discrepancy in how path data is interpreted according to the specification. (Specifically, negative numbers need to have a space before them in the path data.) The fix for this is quick and easy, and the gem can do this for you::

  GameIcons.get(:sheep).correct_pathdata.string # corrects path data
