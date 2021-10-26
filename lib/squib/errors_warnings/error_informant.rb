require 'rainbow/refinement'

module Squib::ErrorInformant
  using Rainbow # we can colorize strings now!

  def attempt(&block)
    begin
      block.yield
    rescue => e
      puts "CAUGHT: #{e.message} #{caller_locations}"
    end
  end
end
