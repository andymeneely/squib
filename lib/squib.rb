autoload :Cairo, 'cairo'
autoload :Pango, 'pango'
autoload :Rsvg,  'rsvg2'
require 'logger'
require 'rainbow/refinement'
require_relative 'squib/version'
require_relative 'squib/commands/cli'
require_relative 'squib/deck'
require_relative 'squib/card'
require_relative 'squib/system_fonts'

module Squib
  using Rainbow # we can colorize strings now!

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
        "[#{datetime.strftime('%F %H:%M:%S')} #{severity.red}] #{msg}\n"
      end
    end
    @logger
  end
  module_function :logger

end
