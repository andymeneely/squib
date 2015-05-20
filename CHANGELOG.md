# Squib CHANGELOG
Squib follows [semantic versioning](http://semver.org).

## v0.6.0 / Unreleased

Features:
* Added `data` field to `svg` to allow for manipulating SVG XML data directly. Works nicely with my new `game_icons` [gem](https://github.com/andymeneely/game_icons) (#65)
* Added `stroke_width` and `stroke_color` to the `text` method to outlines text. (#51)
* Added `hand` method that draws cards around a circle. See hand.rb samples (#64)
* Added an `ellipse` method to (you guessed it) draw ellipses. See the draw_shapes.rb sample (#66)
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