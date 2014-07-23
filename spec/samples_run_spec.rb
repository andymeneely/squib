require 'squib'

describe Squib do 

  it "should execute all examples with no errors" do

    samples = File.expand_path('../samples', File.dirname(__FILE__))
    puts "Samples: #{samples}"
    Dir.chdir(samples) do
      require_relative '../samples/basic.rb'
    end
  end

end