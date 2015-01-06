require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'yard'

task default: [:install, :spec]

RSpec::Core::RakeTask.new(:spec)

YARD::Rake::YardocTask.new(:doc) do |t|
  t.files   = ['lib/**/*.rb', 'samples/**/*.rb']   # optional
  #t.options = ['--any', '--extra', '--opts'] # optional
end
