# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'squib/version'

Gem::Specification.new do |spec|
  spec.name          = "squib"
  spec.version       = Squib::VERSION
  spec.authors       = ["Andy Meneely"]
  spec.email         = ["playconfidencegames@gmail.com"]
  spec.summary       = %q{A Ruby API for prototyping card and other tabletop games}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'cairo', '~> 1.12.9'
  spec.add_runtime_dependency 'pango', '~> 2.2.0'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
