require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'benchmark'
# require 'byebug'

desc 'install + spec'
task default: ['install:local', :spec]

# Useful for hooking up with SublimeText.
# e.g. rake sample[basic.rb]
desc 'Run a specific sample'
task :run, [:file] => :install do |t, args|
  args.with_defaults(file: 'basic.rb')
  Dir.chdir('samples') do
    args[:file] << '.rb' unless args[:file].end_with? '.rb'
    puts "Running samples/#{args[:file]}"
    load args[:file]
  end
end

RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:spec_fastonly) do |t|
  t.rspec_opts = '--tag ~slow'
end

desc 'Run some performance benchmarks'
task benchmark: [:install] do
  require 'squib'
  Squib::logger.level = Logger::ERROR # silence warnings
  Dir.chdir('benchmarks') do
    Benchmark.bm(15) do |bm|
      Dir['*.rb'].each do | script |
        GC.start
        bm.report(script) { load script }
      end
    end
  end
end

desc 'Run sanity tests without a full rebuild'
task :sanity_only do
  require_relative 'spec/sanity/sanity_test.rb'
  SanityTest.new.run
end

desc 'Run full rebuild with sanity tests'
task sanity: [:install, :spec, :sanity_only]
