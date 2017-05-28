require 'logger'
require 'cairo'
require 'pango'
require 'rsvg2'
require_relative 'squib/version'
require_relative 'squib/commands/new'
require_relative 'squib/commands/make_template'
require_relative 'squib/deck'
require_relative 'squib/card'

module Squib

  # Access the internal logger that Squib uses. By default, Squib configure the logger to the WARN level
  # Use this to suppress or increase output levels.
  # @example
  #   Squib.logger.level = Logger::DEBUG #show waaaay more information than you probably need, unless you're a dev
  #   Squib.logger.level = Logger::ERROR #basically turns it off
  #
  # @return [Logger] the ruby logger
  # @api public
  def logger
    if @logger.nil?
      @logger = Logger.new($stdout)
      @logger.level = Logger::WARN
      @logger.formatter = proc do |severity, datetime, m_progname, msg|
        "#{datetime} #{severity}: #{msg}\n"
      end
    end
    @logger
  end
  module_function :logger

end
