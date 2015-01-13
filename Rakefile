require 'squib'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'yard'
require 'benchmark'

task default: [:install, :spec]

RSpec::Core::RakeTask.new(:spec)

YARD::Rake::YardocTask.new(:doc) do |t|
  t.files   = ['lib/**/*.rb', 'samples/**/*.rb']   # optional
  #t.options = ['--any', '--extra', '--opts'] # optional
end

task benchmark: [:install] do
  Squib::logger.level = Logger::ERROR #silence warnings
  Dir.chdir('benchmarks') do
    Benchmark.bm(15) do |bm|
      Dir['*.rb'].each do | script |
        GC.start
        bm.report(script) { load script }
      end
    end
  end
end