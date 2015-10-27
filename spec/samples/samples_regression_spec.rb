require 'spec_helper'
require 'squib'
require 'pp'

describe "Squib samples" do
  @SAMPLES_DIR      = "#{File.expand_path(File.dirname(__FILE__))}/../../samples/"
  let(:samples_dir) { "#{File.expand_path(File.dirname(__FILE__))}/../../samples/" }

  around(:each) do |example|
    Dir.chdir(samples_dir) do
      example.run
    end
  end

  Dir["#{@SAMPLES_DIR}/**/*.rb"].each do |sample|
    it "should execute #{sample} with no errors", slow: true do
      allow(Squib.logger).to receive(:warn) {}
      allow(ProgressBar).to receive(:create).and_return(Squib::DoNothing.new)
      load sample
    end
  end

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
  %w( autoscale_font.rb
      basic.rb
      cairo_access.rb
      csv_import.rb
      config_text_markup.rb
      custom_config.rb
      draw_shapes.rb
      embed_text.rb
      excel.rb
      gradients.rb
      hand.rb
      hello_world.rb
      load_images.rb
      portrait-landscape.rb
      ranges.rb
      saves.rb
      showcase.rb
      text_options.rb
      tgc_proofs.rb
      units.rb
  ).each do |sample|
    it "has not changed for #{sample}", slow: true do
      log = StringIO.new
      mock_cairo(log)
      load sample
      overwrite_sample(sample, log) # Use TEMPORARILY once happy with the new sample log
      test_file_str = File.open(sample_regression_file(sample), 'r:UTF-8').read
      expect(log.string).to eq(test_file_str)
    end
  end

end
