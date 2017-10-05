require 'highline'
require 'spec_helper'
require 'squib'

describe Squib::Commands::MakeSprue do

  describe '#process' do
    before(:each) do
      @in = StringIO.new
      @out = StringIO.new
      @oldpwd = Dir.pwd
      Dir.chdir(output_dir)
    end

    after(:each) do
      Dir.chdir @oldpwd
    end

    it 'creates a custom sheet based on inputs' do
      @in <<
        "1\n" <<     # Units inches
        "4\n" <<     # Paper size A4 landscape
        "0.135\n" << # Sheet margins
        "3\n" <<     # Center align cards
        "2.2\n" <<   # Card width
        "3.5\n" <<   # Card height
        "0\n" <<     # Gap
        "1\n" <<     # Layout cards by row
        "1\n" <<     # Generate crop lines
        "foo.yml\n"  # Output to foo.yml
      @in.rewind
      subject.process({}, @in, @out)
      expect(@out.string).to match(/What measure/)

    end
  end

end
