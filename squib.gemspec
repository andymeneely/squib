# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'squib/version'

Gem::Specification.new do |spec|
  spec.specification_version = 2 if spec.respond_to? :specification_version=
  spec.required_rubygems_version = Gem::Requirement.new('>= 0') if spec.respond_to? :required_rubygems_version=
  spec.rubygems_version = '2.2.2'
  spec.required_ruby_version = '>= 2.7.0'

  spec.name          = 'squib'
  spec.version       = Squib::VERSION
  spec.license       = 'MIT'

  spec.summary       = 'A Ruby DSL for prototyping card games'
  spec.description   = 'Squib is a Ruby DSL for prototyping card games'
  spec.post_install_message   = 'Happy Squibbing!'
  spec.authors       = ['Andy Meneely']
  spec.email         = 'andy.meneely@gmail.com'
  spec.homepage      = 'https://github.com/andymeneely/squib'
  spec.requirements << 'On Windows, you need the Ruby+DevKit. See https://rubyinstaller.org/downloads'

  spec.rdoc_options = ['--charset=UTF-8']
  spec.extra_rdoc_files = Dir['README.md', 'samples/**/*.rb']

  spec.files         = `git ls-files -z`.
                       split("\x0").
                       reject { |f| f.match(%r{^(spec|samples|docs|benchmarks)/}) }
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(spec|samples|docs|benchmarks)\//)
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'cairo',                 '~> 1.17', '>= 1.17.8' # https://rubygems.org/gems/cairo/
  spec.add_runtime_dependency 'classy_hash',           '1.0.0'              # https://rubygems.org/gems/classy_hash
  spec.add_runtime_dependency 'gio2',                  '~> 4.1', '>= 4.1.2'   # https://rubygems.org/gems/gio2
  spec.add_runtime_dependency 'gobject-introspection', '~> 4.1', '>= 4.1.2'   # https://rubygems.org/gems/gobject-introspection
  spec.add_runtime_dependency 'highline',              '2.1.0'              # https://rubygems.org/gems/highline
  spec.add_runtime_dependency 'mercenary',             '0.4.0'              # https://rubygems.org/gems/mercenary
  spec.add_runtime_dependency 'nokogiri',              '~> 1.14', '>= 1.14.2'   # https://rubygems.org/gems/nokogiri
  spec.add_runtime_dependency 'pango',                 '~> 4.1', '>= 4.1.2'   # https://rubygems.org/gems/pango
  spec.add_runtime_dependency 'rainbow',               '~> 3.1'             # https://rubygems.org/gems/rainbow
  spec.add_runtime_dependency 'roo',                   '~> 2.9'             # https://rubygems.org/gems/roo
  spec.add_runtime_dependency 'rsvg2',                 '~> 4.1', '>= 4.1.2'   # https://rubygems.org/gems/rsvg2
  spec.add_runtime_dependency 'ruby-progressbar',      '~> 1.11'            # https://rubygems.org/gems/ruby-progressbar

  spec.add_development_dependency 'activesupport'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'coveralls', '>= 0.8.21'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rake'
  spec.add_development_dependency 'game_icons'
  spec.add_development_dependency 'launchy'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rspec', '~> 3.8'

end
