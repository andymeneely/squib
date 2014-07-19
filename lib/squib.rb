require 'logger'

module Squib

  def logger
    @logger ||= Logger.new(STDOUT)   
  end
  module_function :logger

end

require 'squib/deck'
require 'squib/card'

