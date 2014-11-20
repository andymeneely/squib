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

def layout_file(str)
  "#{File.expand_path(File.dirname(__FILE__))}/data/layouts/#{str}"
end

def sample_file(file)
  "#{File.expand_path(File.dirname(__FILE__))}/../samples/#{file}"
end

def sample_regression_file(file)
  "#{File.expand_path(File.dirname(__FILE__))}/data/samples/#{file}.txt"
end

def overwrite_sample(sample_name, log)
  # Use this to overwrite the regression with current state
  File.open(sample_regression_file(sample_name), 'w+') do |f|
    f.write(log.string.force_encoding("UTF-8")) # write back out to expected file
  end
end

def scrub_hex(str)
  str.gsub(/0x\w{1,8}/,'')
     .gsub(/ptr=\w{1,8}/,'')
     .gsub(/#<Pango::FontDescription:.*>/,'')
     .gsub(/#<Cairo::ImageSurface:.*>/,'ImageSurface')
     .gsub(/#<RSVG::Handle.*>/,'RSVG::Handle')
     .gsub(/RGB:\w{1,8}/,'RGB:')
end

# Build a mock cairo instance that allows basically any method
# and logs that call to the string buffer
def mock_cairo(strio)
  cxt     = double(Cairo::Context)
  surface = double(Cairo::ImageSurface)
  pango   = double(Pango::Layout)
  allow(ProgressBar).to receive(:create).and_return(Squib::DoNothing.new)
  allow(Cairo::Context).to receive(:new).and_return(cxt)
  allow(cxt).to receive(:create_pango_layout).and_return(pango)
  allow(cxt).to receive(:target).and_return(surface)
  allow(pango).to receive(:height).and_return(25)
  allow(pango).to receive(:width).and_return(25)
  allow(pango).to receive(:extents).and_return([Pango::Rectangle.new(0,0,0,0)]*2)

  %w(save set_source_color paint restore translate rotate move_to
    update_pango_layout width height show_pango_layout rounded_rectangle
    set_line_width stroke fill set_source scale render_rsvg_handle circle
    triangle line_to operator= show_page).each do |m|
    allow(cxt).to receive(m) { |*args| strio << scrub_hex("cairo: #{m}(#{args})\n") }
  end

  %w(font_description= text= width= height= wrap= ellipsize= alignment=
    justify= spacing= markup=).each do |m|
    allow(pango).to receive(m) {|*args| strio << scrub_hex("pango: #{m}(#{args})\n") }
  end

  %w(write_to_png).each do |m|
    allow(surface).to receive(m) { |*args| strio << scrub_hex("surface: #{m}(#{args})\n") }
  end
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
