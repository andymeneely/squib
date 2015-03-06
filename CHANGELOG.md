# Squib CHANGELOG

# v0.4.0
* SVG backend support! You can now set the deck's back end to work with SVGs instead of images, making the resulting PDFs vectorized. (You can still save to PNGs too.) This was a big change for Squib, and it's got at least one known issue and probably a few more here and there. See discussion on the README for more details.
* Added config option for antialiasing method. My benchmarks showed that 'best' is only 10% slower than 'fast' on extremely alias-intensive tasks, so 'best' is the Squib default now.
* Bugfix: Stray stroke on circles after text (#35)
* Bugfix: Progress bar increment error (#34)

Known issues
* Masking SVGs onto an SVG backend will rasterize as an intermediate step. (#43)
* Compatibility change: gradient coordinates for the `mask` option in `svg` and `png` commands are relative to the given x,y - NOT to card as it was before.

## v0.3.0
* Masks! The `png` and `svg` commands can be used as if they are a mask, so you can color the icon with any color you like. Can be handy for switching to black-and-white, or for reusing the same image but different colors across cards.
* Gradients! Can now specify linear or radial gradients anywhere you specify colors. See README and `samples/gradients.rb` for more details.
* Number padding! `save_png` will now pad zeros on the filenames for friendlier sorting. You can also specify your own with `count_format` using the classical format string from Ruby's `Kernel::sprintf` (mostly just C-style format strings). Default: `'%02d'. The `prefix:` option is still there too.
* Added unit conversion to `Squib::New` and `save_pdf`
* Added arbitrary paper sizes to `save_pdf`
* Added new sample table for color viewing constants in `samples/colors.rb`

Special thanks to [Shalom Craimer](https://github.com/scraimer) for the idea and proof-of-concept on gradient and mask features!

## v0.2.0
* Added `showcase` feature to create a fancy-looking 3D reflection to showcase your cards. Documented, tested, and added a sample for it.
* Added a basic Rakefile, documented in README.
* Some internal refactoring, better testing, and more documentation with layouts

## v0.1.0
* Added `save_sheet` command that saves a range into PNG sheets, complete with trim, gap, margin, columns, and sometimes automagically computed rows. See samples/saves.rb.
* Unit conversion! Now you can write "2in" and it will convert based on the current dpi. `save_pdf` not supported (yet).
* `png` now supports resizing, but warns you about it since it's non-ideal. Documented in yard, tested.
* Added sample `unicode.rb` to show lots of game-related unicode characters
* More obsessive automated testing and continuous integration work.

## v0.0.6
* Added a `csv` command that works just like `xslx`. Uses Ruby's CSV inside, with some extra checking and warnings.
* Custom layouts now support loading & merging multiple Yaml files! Updated README, docs, and sample to document it.
* Built-in layouts! Currently we support `hand.yml` and `playing-card.yml`. Documented in the `layouts.rb` sample.
* `text` now returns the ink extent rectangle of the rendered text. Updated docs and sample to document it.
* Samples now show that you can use text instead of symbols for things like `center`
* Improved logging, and documentation on increasing logger verboseness
* Better regression testing technique that tracks when a sample has changed.
* Bumped version of Cairo to ~> 1.14

## v0.0.5
* Image rotation for png and svg via `angle`
* New sample for demonstrating direct cairo access
* README now includes a snazzy screencast of the Sublime snippets
* Rotation of text works more conventionally now, and works with text hints
* Better code styles thanks to RuboCop
* Better unit testing, now with mocking!
* Various version bumps: rspec, yard

## v0.0.4
* Added a font size override so you can vary the font size with the same style across strings more easily
* Added text autoscale sample
* Added `extends` to custom layouts, allowing ways to modify parent data instead of just overriding it.
* Upgraded ruby-progressbar version
* Added text rotation (thanks novalis!)
* Fixed a mapping problem with triangles (thanks novalis!)
* Fixed global hint togglability

## v0.0.3
* Redesigned the dynamic options system to make adding new commands much easier
* Singleton expansion
* Better documentation in README and throughout
* Implemented Junk Land in this version

## v0.0.1-v0.0.2
* Primordial era - base functionality