require 'simplecov'
require 'coveralls'
# require 'byebug'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
])
SimpleCov.start

require 'squib'

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.tty = true
  config.color = true
end

def tmp_dir
  "#{File.expand_path(File.dirname(__FILE__))}/../tmp"
end

def samples_dir
  File.expand_path("#{File.dirname(__FILE__)}/../samples")
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

def csv_file(file)
  "#{File.expand_path(File.dirname(__FILE__))}/data/csv/#{file}"
end

def xlsx_file(file)
  "#{File.expand_path(File.dirname(__FILE__))}/data/xlsx/#{file}"
end

def project_template(file)
  "#{File.expand_path(File.dirname(__FILE__))}/../lib/squib/project_template/#{file}"
end

def conf(file)
  "#{File.expand_path(File.dirname(__FILE__))}/data/conf/#{file}"
end

def overwrite_sample(sample_name, log)
  # Use this to overwrite the regression with current state
  File.open(sample_regression_file(sample_name), 'w+:UTF-8') do |f|
    f.write(log.string)
  end
end

def scrub_hex(str)
  str.gsub(/0x\w{1,8}/, '')
     .gsub(/ptr=\w{1,8}/, '')
     .gsub(/#<Pango::FontDescription:.*>/, '')
     .gsub(/#<Pango::AttrList:.*>/, 'Pango::AttrList')
     .gsub(/#<Cairo::ImageSurface:.*>/, 'ImageSurface')
     .gsub(/#<Cairo::LinearPattern:.*>/, 'LinearPattern')
     .gsub(/#<Cairo::RadialPattern:.*>/, 'RadialPattern')
     .gsub(/#<Cairo::Matrix:.*>/, 'Matrix')
     .gsub(/#<RSVG::Handle.*>/, 'RSVG::Handle')
     .gsub(/#<RSpec::Mocks::Double:.*>/, 'MockDouble')
     .gsub(/#<Double .*>/, 'MockDouble')
     .gsub(/RGB:\w{1,8}/, 'RGB:')
end

# Build a mock cairo instance that allows basically any method
# and logs that call to the string buffer
def mock_cairo(strio)
  cxt       = double(Cairo::Context)
  surface   = double(Cairo::ImageSurface)
  pango     = double(Pango::Layout)

  font      = double(Pango::FontDescription)
  iter      = double('pango_iter')
  pango_cxt = double('pango_cxt')
  allow(Squib.logger).to receive(:warn) {}
  allow(ProgressBar).to receive(:create).and_return(Squib::DoNothing.new)
  allow(Cairo::ImageSurface).to receive(:new).and_return(surface)
  allow(surface).to receive(:width).and_return(100)
  allow(surface).to receive(:height).and_return(101)
  allow(surface).to receive(:ink_extents).and_return([0, 0, 100, 100])
  allow(Cairo::Context).to receive(:new).and_return(cxt)
  allow(cxt).to receive(:create_pango_layout).and_return(pango)
  allow(cxt).to receive(:target).and_return(surface)
  allow(cxt).to receive(:matrix).and_return(Cairo::Matrix.new(1, 0, 0, 1, 0, 0))
  allow(pango).to receive(:height).and_return(25)
  allow(pango).to receive(:width).and_return(25)
  allow(pango).to receive(:index_to_pos).and_return(Pango::Rectangle.new(0, 0, 0, 0))
  allow(pango).to receive(:extents).and_return([Pango::Rectangle.new(0, 0, 0, 0)] * 2)
  allow(pango).to receive(:iter).and_return(iter)
  allow(pango).to receive(:alignment).and_return(Pango::Layout::Alignment::LEFT)
  allow(pango).to receive(:text).and_return('foo')
  allow(pango).to receive(:context).and_return(pango_cxt)
  allow(pango).to receive(:attributes).and_return(nil)
  allow(pango_cxt).to receive(:set_shape_renderer)
  allow(pango_cxt).to receive(:font_options=)
  allow(iter).to receive(:next_char!).and_return(false)
  allow(iter).to receive(:char_extents).and_return(Pango::Rectangle.new(5, 5, 5, 5))
  allow(iter).to receive(:index).and_return(1000)
  allow(Pango::FontDescription).to receive(:new).and_return(font)
  allow(Cairo::PDFSurface).to receive(:new).and_return(nil)

  %w(save set_source_color paint restore translate rotate move_to
    update_pango_layout width height show_pango_layout rounded_rectangle
    set_line_width stroke fill set_source scale render_rsvg_handle circle
    triangle line_to operator= show_page clip transform mask rectangle
    reset_clip antialias= curve_to matrix= pango_layout_path stroke_preserve
    fill_preserve close_path set_dash set_line_cap set_line_join).each do |m|
    allow(cxt).to receive(m) { |*args| strio << scrub_hex("cairo: #{m}(#{args})\n") }
  end

  %w(font_description= text= width= height= wrap= ellipsize= alignment=
    justify= spacing= markup= ellipsized? attributes=
    set_shape_renderer).each do |m|
    allow(pango).to receive(m) {|*args| strio << scrub_hex("pango: #{m}(#{args})\n") }
  end

  %w(size=).each do |m|
    allow(font).to receive(m) { |*args| strio << scrub_hex("pango font: #{m}(#{args})\n") }
  end

  %w(write_to_png finish).each do |m|
    allow(surface).to receive(m) { |*args| strio << scrub_hex("surface: #{m}(#{args})\n") }
  end

  %w(next_char!).each do |m|
    allow(iter).to receive(m) { |*args| strio << scrub_hex("pango_iter: #{m}(#{args})\n") }
  end

end

# Refine Squib to allow setting the logger and progress bar
module Squib
  def logger=(l)
    @logger = l
  end
  module_function :logger=

  class Deck
    attr_accessor :progress_bar
  end
end

def output_dir
  File.expand_path('../samples/_output', File.dirname(__FILE__))
end
