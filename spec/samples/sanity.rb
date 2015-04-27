require 'launchy'
require 'erb'

# An pixel-by-pixel comparison of sample images for visual regression testing
class Sanity

  @@EXPECTED_DIR = "#{File.expand_path(File.dirname(__FILE__))}/expected/"
  @@OUTPUT_DIR   = "#{File.expand_path(File.dirname(__FILE__))}/../../samples/_output/"
  @@SANITY_ERB   = "#{File.expand_path(File.dirname(__FILE__))}/sanity.html.erb"
  @@SANITY_HTML  = "#{File.expand_path(File.dirname(__FILE__))}/sanity.html"

  def images
    images = {}
    Dir[@@EXPECTED_DIR + "/**/*.png"].each do |exp_png|
      images["file:///" + exp_png] = "file:///" + @@OUTPUT_DIR + File.basename(exp_png)
    end
    return images
  end

  def run
    puts "Building sanity test..."
    sanity_template = File.read(@@SANITY_ERB)
    process_erb(sanity_template)
    # render_markdown(sanity_template)
    Launchy.open("file:///" + @@SANITY_HTML)
    puts "Done."
  end

  private

  def process_erb(sanity_template)
    renderer = ERB.new(sanity_template)
    File.open(@@SANITY_HTML, 'w+') do |html|
      html.write(renderer.result(binding))
    end
  end

  # def render_markdown(sanity_template)
  #   md = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
  #   File.open(@@SANITY_HTML, 'w+') do |html|
  #     html.write(md.render(sanity_template))
  #   end
  # end

end