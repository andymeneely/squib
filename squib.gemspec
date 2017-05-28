# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'squib/version'

Gem::Specification.new do |spec|
  spec.specification_version = 2 if spec.respond_to? :specification_version=
  spec.required_rubygems_version = Gem::Requirement.new('>= 0') if spec.respond_to? :required_rubygems_version=
  spec.rubygems_version = '2.2.2'
  spec.required_ruby_version = '>= 2.2.0'

  spec.name          = 'squib'
  spec.version       = Squib::VERSION
  spec.license       = 'MIT'

  spec.summary       = 'A Ruby DSL for prototyping card games'
  spec.description   = 'Squib is a Ruby DSL for prototyping card games'
  spec.authors       = ['Andy Meneely']
  spec.email         = 'andy.meneely@gmail.com'
  spec.homepage      = 'https://github.com/andymeneely/squib'

  spec.rdoc_options = ['--charset=UTF-8']
  spec.extra_rdoc_files = Dir['README.md', 'samples/**/*.rb']

  spec.files         = `git ls-files -z`.
                       split("\x0").
                       reject { |f| f.match(%r{^(spec|samples|docs|benchmarks)/}) }
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(spec|samples|docs|benchmarks)\//)
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'cairo',                 '~> 1.15.5'
  spec.add_runtime_dependency 'gio2',                  '~> 3.1.1'
  spec.add_runtime_dependency 'gobject-introspection', '~> 3.1.1'
  spec.add_runtime_dependency 'mercenary',             '~> 0.3.4'
  spec.add_runtime_dependency 'nokogiri',              '~> 1.7.0'
  spec.add_runtime_dependency 'pango',                 '~> 3.1.1'
  spec.add_runtime_dependency 'roo',                   '~> 2.7.0'
  spec.add_runtime_dependency 'rsvg2',                 '~> 3.1.1'
  spec.add_runtime_dependency 'ruby-progressbar',      '~> 1.8'
  spec.add_runtime_dependency 'highline',              '~> 1.7.8'
  spec.add_runtime_dependency 'classy_hash',           '~> 0.1'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'coveralls'
  # spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'launchy'
  spec.add_development_dependency 'game_icons'

end
