require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'yard'

RSpec::Core::RakeTask.new(:spec)
task default: [:install, :spec]

YARD::Rake::YardocTask.new(:doc) do |t|
  t.files   = ['lib/**/*.rb', 'samples/**/*.rb']   # optional
  #t.options = ['--any', '--extra', '--opts'] # optional
end
