require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'yard'
require 'benchmark'
require 'byebug'

task default: [:install, :spec]

# Useful for hooking up with SublimeText.
# e.g. rake sample[basic.rb]
task :run,[:file] => :install do |t, args|
  args.with_defaults(file: 'basic.rb')
  Dir.chdir('samples') do
    args[:file]  << ".rb" unless args[:file].end_with? '.rb'
    puts "Running samples/#{args[:file]}"
    load args[:file]
  end
end


RSpec::Core::RakeTask.new(:spec)

task doc: [:yarddoc, :apply_google_analytics]

YARD::Rake::YardocTask.new(:yarddoc) do |t|
  t.files   = ['lib/**/*.rb', 'samples/**/*.rb']   # optional
  #t.options = ['--any', '--extra', '--opts'] # optional
end

task benchmark: [:install] do
  require 'squib'
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

task :apply_google_analytics do
  # The string to replace in the html document. This is chosen to be the end
  # body </body> tag. So the script can be injected as the last thing in the
  # document body.
  string_to_replace = "</body>"
  # This is the string to replace with. It include the google analytics script
  # as well as the end </body> tag.
  string_to_replace_with = <<-EOF
    <script>
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

      ga('create', 'UA-54811605-1', 'auto');
      ga('send', 'pageview');

   </script>
  </body>
  EOF

  files = Dir.glob("doc/**/*.html")

  files.each do |html_file|
    puts "Processing file: #{html_file}"
    contents = ""
    # Read the file contents
    file =  File.open(html_file)
    file.each { |line| contents << line }
    file.close

    # If the file already has google analytics tracking info, skip it.
    if contents.include?(string_to_replace_with)
      puts "Skipped..."
      next
    end

    # Apply google analytics tracking info to the html file
    contents.gsub!(string_to_replace, string_to_replace_with)

    # Write the contents with the google analytics info to the file
    file =  File.open(html_file, "w")
    file.write(contents)
    file.close
  end
end
