# Squib CHANGELOG

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