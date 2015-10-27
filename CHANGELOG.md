# Squib CHANGELOG
Squib follows [semantic versioning](http://semver.org).

## v0.9.0 / Unreleased

Features:
* Crop your PNGs! This means you can work from spritesheets if you want. New options to `png` are documented in the API docs and in the `load_images.rb` sample. (#11)

Chores:
* Ripped out a lot of old constants used from the old way we handled arguments. Yay negative churn!
* Emit a warning when a `config.yml` option is not recognized

## v0.8.0 / 2015-10-26
Features
* The `xlsx` and `csv` support quantity explosion! Just use the column name 'Qty' and put integers in your sheet and you'll produce copies of the entire row. See README and the csv sample for more info. (#78)
* The `xlsx` and `csv` methods will now strip leading and trailing whitespace by default where applicable. This is now turned on by default, but can be turned off with `strip: false`. (#79)
* The `xlsx` and `csv` methods will now yield to a block (if given) for each cell so you can do some extra processing if you like. See samples/excel.rb for an example. (#108)
* Layout file for TheGameCrafter tuck boxes (#113). Thanks @alexgorski!

Compatibility change:
* Stripping leading and trailing whitespace of xlsx and csv values by default might change how your data gets parsed.

Bugs fixes:
* The `range` option everywhere doesn't fail on `[]` (#107)

## v0.7.0 / 2015-09-11

Features
* Added `cap` option to `line` and `curve` to define how ends of lines are drawn (#42)
* Added `join` option to all drawing operations (e.g. `rect`, `star`, even outlines for `text`) to define how corners are drawn. (#42)
* Added `dash` option to all drawing operations (e.g. `rect`, `star`, even outlines for `text`) so you can specify your own dash pattern. Just specify a string with space-separated numbers to specify the on-and-off alternating pattern (e.g. `dash: '2 2'` with a stroke width of `2` is evenly spaced dots). Supports unit conversion (e.g. `dash: '0.02in 0.02in'`) (#42)
* Added an idiom to the `ranges.rb` sample for drawing a different number of images based on the column in a table (e.g. 2 arrows to indicate 2 actions). Based on question #90. There are probably even cleaner, Ruby-ish ways to do this too - pull requests are welcome.
* The `text` method and several other methods will throw errors on invalid input. This means your scripts will be more likely to break if you provide bad input. Please report bugs if you thinkg this unfairly breaks your code.
* The `text` embedding icon now allows singleton expansion, which means that you can have icons have different sizes on different cards. The sample `embed_text.rb` demonstrates this. (#54)
* The `text` method will throw a warning when it needs to ellipsize text (i.e. too much text for a fixed-size text box). Can be turned off in `config.yml`. (#80)
* Upgraded roo (Excel parsing) to 2.1.0. Macro-enabled Excel files can be parsed now (i.e. `xlsm`), although I've only mildly tested this. (cddea47ba56add286639e493d5cc0146245eca68)
* New built-in layouts: `fantasy.yml` and `economy.yml`. Demonstrated in new sample `layouts_builtin.rb` (#97)
* Added `:scale` shortcut to `width` and `height` options for `png` and `svg`. Allows you to set the width and the image will scale while keeping its aspect ratio. (e.g. `svg width: 500, height: :scale`) (#91)
* Upgraded cairo dependency to 1.14.3, which silences some warnings on Macs and upgrades a lot of Windows dependencies.
* Upgraded pango, librsvg dependencies to 3.0.0, which focused mainly on upgrading Windows dependencies.

Compatibility:
* All drawn shapes (e.g. circle, triangle, star) will now draw their stroke on top of the fill. This was not consistent before, and now it is (because Squib is more DRY about it!). This means that your `stroke_width` might render wider than before. If you want the other behavior, specify `stroke_strategy: :stroke_first`. Also applies to `text` when `stroke_width` is specified.
* The `width` and `height` options for `text` have changed their defaults from `:native` to `:auto`. This is to differentiate them from `:native` widths that default elsewhere.  Additionally, `width` and `height` for shapes now default to `:deck`, and get interpreted as the deck width and height. The `:native` options are interpreted for SVG and PNG images as their original values. The behavior is all the same, just with more specific names.
* Removed `img_dir` from the `set` method. You can still set `img_dir` in the configuration file (e.g. `config.yml`). Added a deprecation error.

Bugs:
* Fixed a `Cairo::WriteError` on `save_sheet` (#56, PR #96 thank you @meltheadorable!)
* Investigated a NoMemoryError on Macs. Solution: upgrade to Ruby 2.2. (#88)

Chores:
* Refactoring to make internal drawing code more DRY (#75, and much more). This is a big re-design that will help ease future features that involve manipulating arguments. Trust me. This was worth the wait and all the hard work.
* Better testing and general flexibility around the `range` option.

## v0.6.0 / 2015-05-26

Features:
* Added `data` field to `svg` to allow for manipulating SVG XML data directly. Works nicely with my new `game_icons` [gem](https://github.com/andymeneely/game_icons) (#65)
* Added `stroke_width` and `stroke_color` to the `text` method to outlines text. (#51)
* Added `hand` method that draws cards around a circle. See hand.rb samples (#64)
* Added an `ellipse` method to (you guessed it) draw ellipses. See the draw_shapes.rb sample (#66)
* Added a `star` method to (you guessed it) draw stars. See the draw_shapes.rb sample (#72)
* Added a `polygon` method to (you guessed it) draw polygons. See the draw_shapes.rb sample (#67)
* Upgraded roo (Excel parsing) to 2.0.0. Nothing major for Squib users, just keeping up with the times.

Bugs:
* Text embed svg and png commands default to integer so the README example works (#73).
* Fixed global text hinting (#63)
* Fixed a broken promise about fill_color in `showcase` (#71)

Compatbility:
* rsvg2 and pango updated to v2.2.5. Squib follows 2.2.x of both of those. If you run `bundle` you will automatically be upgraded. They appear to be mostly bugfix releases.
* dpi is currently removed from `config.yml` and is ONLY available in `Squib::Deck.new`. This may change in the future, however.

Chores:
* Massive internal redesigning of the way configuration options are parsed, stored, handled. No real changes are visible to the user, but this code will be more maintainable and open up the door for more flexible configuration options in the future.
* Added `rake sanity` as a visual regression test to ensure the samples don't break
* Lots of automated test refactoring

Thanks to [pickfifteen](https://github.com/pickfifteen), and [Brian Cronin](http://www.boardgamegeek.com/user/MurphyIdiot) for the bug reports!

## v0.5.1 / 2015-04-13

Bugs:
* Fixed a PDF scaling issue, so now page width and height is properly calculated from DPI (#62)

Thanks to [Brian Cronin](http://www.boardgamegeek.com/user/MurphyIdiot) for the bug report.

## v0.5.0 / 2015-04-13
Features:
* Embedding of SVGs and PNGs into text! See README, `text_options.rb`, and `embed_text.rb`, and API documentation. This was a finnicky feature, so feedback and bug reports are welcome. (#30)
* Curves! We can now do Bezier curves. Documented, and added to the sample `draw_shapes.rb` (#37).
* Smart Quotes! The `text` rule now has a `quotes: 'smart'` option where straight quotes get converted to curly quotes. Assumes UTF-8, or you can specify your own quote characters if you're not in UTF-8. (#50)
* Font-level antialiasing is inherited from global antialiasing setting (workaround until we get a better solution for #59).

Known issues
* OSX Yosemite will show this warning: `<Error>: The function ‘CGFontGetGlyphPath’ is obsolete and will be removed in an upcoming update. Unfortunately, this application, or a library it uses, is using this obsolete function, and is thereby contributing to an overall degradation of system performance.` This warning will go away when the Ruby Cairo bindings upgrades from 1.14.1 to 1.14.2.

Special thanks to [pickfifteen](https://github.com/pickfifteen) for testing, feedback, and pull requests!!

## v0.4.0 / 2015-04-28

Features:
* SVG backend support! You can now set the deck's back end to work with SVGs instead of images, making the resulting PDFs vectorized. (You can still save to PNGs too.) This was a big change for Squib, and it's got at least one known issue and probably a few more here and there. See discussion on the README for more details.
* Added config option for antialiasing method. My benchmarks showed that 'best' is only 10% slower than 'fast' on extremely alias-intensive tasks, so 'best' is the Squib default now.

Bugs:
* Stray stroke on circles after text (#35)
* Progress bar increment error (#34)

Known issues
* Masking SVGs onto an SVG backend will rasterize as an intermediate step. (#43)
* Compatibility change: gradient coordinates for the `mask` option in `svg` and `png` commands are relative to the given x,y - NOT to card as it was before.

## v0.3.0 / 2015-02-02

Features:
* Masks! The `png` and `svg` commands can be used as if they are a mask, so you can color the icon with any color you like. Can be handy for switching to black-and-white, or for reusing the same image but different colors across cards.
* Gradients! Can now specify linear or radial gradients anywhere you specify colors. See README and `samples/gradients.rb` for more details.
* Number padding! `save_png` will now pad zeros on the filenames for friendlier sorting. You can also specify your own with `count_format` using the classical format string from Ruby's `Kernel::sprintf` (mostly just C-style format strings). Default: `'%02d'. The `prefix:` option is still there too.
* Added unit conversion to `Squib::New` and `save_pdf`
* Added arbitrary paper sizes to `save_pdf`
* Added new sample table for color viewing constants in `samples/colors.rb`

Special thanks to [Shalom Craimer](https://github.com/scraimer) for the idea and proof-of-concept on gradient and mask features!

## v0.2.0 / 2015-01-12

Features:
* Added `showcase` feature to create a fancy-looking 3D reflection to showcase your cards. Documented, tested, and added a sample for it.
* Added a basic Rakefile, documented in README.
* Some internal refactoring, better testing, and more documentation with layouts

## v0.1.0 / 2014-12-31

Features:
* Added `save_sheet` command that saves a range into PNG sheets, complete with trim, gap, margin, columns, and sometimes automagically computed rows. See samples/saves.rb.
* Unit conversion! Now you can write "2in" and it will convert based on the current dpi. `save_pdf` not supported (yet).
* `png` now supports resizing, but warns you about it since it's non-ideal. Documented in yard, tested.
* Added sample `unicode.rb` to show lots of game-related unicode characters

Chores:
* More obsessive automated testing and continuous integration work.

## v0.0.6 / 2014-12-08

Features:
* Added a `csv` command that works just like `xslx`. Uses Ruby's CSV inside, with some extra checking and warnings.
* Custom layouts now support loading & merging multiple Yaml files! Updated README, docs, and sample to document it.
* Built-in layouts! Currently we support `hand.yml` and `playing-card.yml`. Documented in the `layouts.rb` sample.
* `text` now returns the ink extent rectangle of the rendered text. Updated docs and sample to document it.
* Samples now show that you can use text instead of symbols for things like `center`

Chores:
* Improved logging, and documentation on increasing logger verboseness
* Better regression testing technique that tracks when a sample has changed.
* Bumped version of Cairo to ~> 1.14

## v0.0.5 / 2014-11-03
* Image rotation for png and svg via `angle`
* New sample for demonstrating direct cairo access
* README now includes a snazzy screencast of the Sublime snippets
* Rotation of text works more conventionally now, and works with text hints
* Better code styles thanks to RuboCop
* Better unit testing, now with mocking!
* Various version bumps: rspec, yard

## v0.0.4 / 2014-10-17
* Added a font size override so you can vary the font size with the same style across strings more easily
* Added text autoscale sample
* Added `extends` to custom layouts, allowing ways to modify parent data instead of just overriding it.
* Upgraded ruby-progressbar version
* Added text rotation (thanks novalis!)
* Fixed a mapping problem with triangles (thanks novalis!)
* Fixed global hint togglability

## v0.0.3 / 2014-08-30
* Redesigned the dynamic options system to make adding new commands much easier
* Singleton expansion
* Better documentation in README and throughout
* Implemented Junk Land in this version

## v0.0.1-v0.0.2 / 2014-07-29
* Primordial era - base functionality
