require 'logger'
require 'cairo'
require 'pango'
require 'rsvg2'
require 'squib/version'
require 'squib/commands/new'
require 'squib/deck'
require 'squib/card'

module Squib

  def logger
    @logger ||= Logger.new(STDOUT)
  end
  module_function :logger
  
end