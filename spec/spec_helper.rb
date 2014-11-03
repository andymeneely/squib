require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'squib'

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

def test_file(str)
  "#{File.expand_path(File.dirname(__FILE__))}/data/#{str}"
end

# Refine Squib to allow setting the logger and progress bar
module Squib
  def logger=(l)
    @logger = l
  end
  module_function 'logger='

  class Deck
    attr_accessor :progress_bar
  end
end

def mock_squib_logger(old_logger)
  old_logger = Squib.logger
  Squib.logger = instance_double(Logger)
  yield
  Squib.logger = old_logger
end

def output_dir
  File.expand_path('../samples/_output', File.dirname(__FILE__))
end
