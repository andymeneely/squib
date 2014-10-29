require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

def test_file(str)
  "#{File.expand_path(File.dirname(__FILE__))}/data/#{str}"
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
