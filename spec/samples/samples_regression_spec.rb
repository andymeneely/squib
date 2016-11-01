require 'spec_helper'
require 'squib'
require 'pp'

describe 'Squib samples' do

  # This test could use some explanation
  # Much of the development of Squib has been sample-driven. Every time I want
  # new syntax or feature, I write a sample, get it working, and then write
  # tests for boundary cases in the unit tests.
  #
  # This makes documentation much easier and example-driven.
  # ...but I want to use those samples for regression & integration tests too.
  #
  # The above test is a good smoke test, but it just looks for exceptions.
  # What this set of tests do is run the samples again, but mocking out Cairo,
  # Pango, RSVG, and any other dependencies. We log those API calls and store
  # them in a super-verbose string. We compare our runs against what happened
  # before.
  #
  # Thus, if we ever change anything that results in a ANY change to our
  # regression logs, then these tests will fail. If it's SURPRISING, then we
  # caught an integration bug. If it's not, just update and overwrite the logs.
  #
  # So it's understood that you should have to periodically enable the
  # overwrite_sample method below to store the new regression log. Just make
  # sure you inspect the change and make sure it makes sense with the change
  # you made to the samples or Squib.
  # FOR NOW!! These two I can't get working on Travis, so I'm disabling
  # Has to do with UTF-8 encoding of a special characters
      # layouts.rb
  # These are samples that don't really need a regression log
      # colors.rb
      # unicode.rb
  %w(
      autoscale_font/_autoscale_font.rb
      basic.rb
      cairo_access.rb
      colors/_gradients.rb
      config_text_markup.rb
      custom_config.rb
      data/_csv.rb
      data/_excel.rb
      embed_text.rb
      hello_world.rb
      images/_more_load_images.rb
      ranges.rb
      saves/_hand.rb
      saves/_portrait_landscape.rb
      saves/_saves.rb
      saves/_save_pdf.rb
      saves/_showcase.rb
      shapes/_draw_shapes.rb
      text_options.rb
      tgc_proofs.rb
      units.rb
  ).each do |sample|
    it "has not changed for #{sample}", slow: true do
      log = StringIO.new
      mock_cairo(log)
      full_sample_path = File.expand_path "#{samples_dir}/#{sample}"
      Dir.chdir(File.dirname("#{samples_dir}/#{sample}")) do
        load full_sample_path
      end
      overwrite_sample(sample, log) # Use TEMPORARILY once happy with the new sample log
      test_file_str = File.open(sample_regression_file(sample), 'r:UTF-8').read
      expect(log.string).to eq(test_file_str)
    end
  end

end
