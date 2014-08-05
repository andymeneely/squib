require 'spec_helper'
require 'squib'

describe  Squib::Commands::New do 

  describe "#process" do 
    before(:all) do
      @old_stderr = $stderr
      $stderr = StringIO.new
      @oldpwd = Dir.pwd
      Dir.chdir(File.expand_path('../../samples/_output', File.dirname(__FILE__)))
    end

    before(:each) do
      FileUtils.rm_rf('foo', secure: true)
      @cmd = Squib::Commands::New.new
    end

    it "raises an error if no directory was specified" do
      expect{@cmd.process([])}.to raise_error(ArgumentError, 'Please specify a path.')
    end

    it "creates a new template on an fresh directory" do
      @cmd.process(['foo'])
      expect(File.exists?('foo/deck.rb')).to be true
    end

    it "creates a new template on an empty directory" do
      Dir.mkdir('foo')
      @cmd.process(['foo'])
      expect(File.exists?('foo/deck.rb')).to be true
    end

    it "does not create a new template on an empty " do
      Dir.mkdir('foo')
      File.new('foo/somefile.txt', 'w+')
      @cmd.process(['foo'])
      $stderr.rewind
      expect($stderr.string.chomp).to end_with " exists and is not empty. Doing nothing and quitting."
    end

    after(:all) do
      $stderr = @old_stderr
      Dir.chdir(@oldpwd)
    end
end
  
end