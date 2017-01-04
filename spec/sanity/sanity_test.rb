require 'launchy'
require 'erb'
require 'yaml'

# An pixel-by-pixel comparison of sample images for visual regression testing
class SanityTest

  def sanity_html_erb
    "#{File.expand_path(File.dirname(__FILE__))}/sanity.html.erb"
  end

   def sanity_html
     "#{File.expand_path(File.dirname(__FILE__))}/sanity.html"
   end

  def samples_dir
    File.expand_path "samples/"
  end

  def images
    Dir["#{samples_dir}/**/*_expected.{png,svg}"].map do |expected|
      actual = [ File.dirname(expected),
                 "/_output/",
                File.basename(expected).gsub('_expected', '')].join
      [expected, actual]
    end
  end

  def run
    puts 'Building sanity test...'
    process_erb(File.read(sanity_html_erb))
    Launchy.open('file:///' + sanity_html)
    puts 'Done.'
  end

  private

  def process_erb(sanity_template)
    renderer = ERB.new(sanity_template)
    File.open(sanity_html, 'w+') do |html|
      html.write(renderer.result(binding))
    end
  end

end
