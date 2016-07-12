require 'launchy'
require 'erb'
require 'yaml'

# An pixel-by-pixel comparison of sample images for visual regression testing
class SanityTest

  @@ERB      = "#{File.expand_path(File.dirname(__FILE__))}/sanity.html.erb"
  @@HTML     = "#{File.expand_path(File.dirname(__FILE__))}/sanity.html"
  @@COMPARES = "#{File.expand_path(File.dirname(__FILE__))}/tests.yml"
  @@SAMPLES  = "file:///#{File.expand_path("samples/")}"

  def images
    require 'pp'
    comps = YAML.load_file(@@COMPARES)
    pp comps
    comps.each do | test, data |
      pp data
    end
    [
      ["#{@@SAMPLES}/images/_images_00_expected.png", "#{@@SAMPLES}/images/_images_00.png"]
    ]
  end

  def run
    puts @@SAMPLES
    puts 'Building sanity test...'
    process_erb(File.read(@@ERB))
    Launchy.open('file:///' + @@HTML)
    puts 'Done.'
  end

  private

  def process_erb(sanity_template)
    renderer = ERB.new(sanity_template)
    File.open(@@HTML, 'w+') do |html|
      html.write(renderer.result(binding))
    end
  end

end
