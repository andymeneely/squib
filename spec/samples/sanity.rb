require 'launchy'
require 'erb'
require 'cairo'
require 'ruby-progressbar'

# An pixel-by-pixel comparison of sample images for visual regression testing
class Sanity

  @@EXPECTED_DIR = "#{File.expand_path(File.dirname(__FILE__))}/expected/"
  @@OUTPUT_DIR   = "#{File.expand_path(File.dirname(__FILE__))}/../../samples/_output/"
  @@DIFF_DIR     = "#{File.expand_path(File.dirname(__FILE__))}/_diffs/"
  @@SANITY_ERB   = "#{File.expand_path(File.dirname(__FILE__))}/sanity.html.erb"
  @@SANITY_HTML  = "#{File.expand_path(File.dirname(__FILE__))}/sanity.html"

  def images
    images   = []
    exp_pngs = Dir[@@EXPECTED_DIR + "/**/*.png"]
    bar      = ProgressBar.create(title: 'Diffing images', total: exp_pngs.size)
    exp_pngs.each do |exp_png|
      row = []
      actual_png = @@OUTPUT_DIR + File.basename(exp_png)
      row << "file:///" + exp_png
      row << "file:///" + actual_png # actual
      row << "file:///" + diff_image(exp_png, actual_png)
      images << row
      bar.increment
    end
    bar.finish
    return images
  end

  def run
    puts "Building sanity test..."
    sanity_template = File.read(@@SANITY_ERB)
    process_erb(sanity_template)
    Launchy.open("file:///" + @@SANITY_HTML)
    puts "Done."
  end

  private

  def diff_image(exp_file, actual_file)
    exp         = Cairo::ImageSurface.from_png(exp_file)
    exp_data    = exp.data.bytes
    actual_data = Cairo::ImageSurface.from_png(actual_file).data.bytes
    new_data    = Array.new(exp_data.size, 255)
    unless exp_data == actual_data # this seems to be the fastest initial comparison
      (0..exp_data.size).each do |i|
        empty = (i % 4 == 3) ? 0 : 255 # alpha channel is empty, others are just black
        new_data[i] = (exp_data[i] == actual_data[i]) ? empty : 128
      end
    end
    out = Cairo::ImageSurface.new(new_data.pack('c*'), exp.format, exp.width, exp.height, exp.stride)
    out_file = @@DIFF_DIR + exp_file[exp_file.rindex("/")..-1]
    out.write_to_png(out_file)
    out_file
  end

  def diff_pixel(exp, actual)
    (exp == actual) ? [0, 0, 0, 0] : [255, 0, 0, 255]
  end

  def process_erb(sanity_template)
    renderer = ERB.new(sanity_template)
    File.open(@@SANITY_HTML, 'w+') do |html|
      html.write(renderer.result(binding))
    end
  end

end