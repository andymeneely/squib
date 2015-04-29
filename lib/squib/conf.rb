require 'squib'
require 'forwardable'
require 'squib/args/typographer'

module Squib
  # @api private
  class Conf

    DEFAULTS = {
      'antialias'     => 'best',
      'backend'       => 'memory',
      'count_format'  => SYSTEM_DEFAULTS[:count_format],
      'custom_colors' => {},
      'dir'           => SYSTEM_DEFAULTS[:dir],
      'hint'          => :none,
      'img_dir'       => '.',
      'progress_bars' => false,
      'ldquote'       => "\u201C", # UTF8 chars
      'rdquote'       => "\u201D",
      'lsquote'       => "\u2018",
      'rsquote'       => "\u2019",
      'em_dash'       => "\u2014",
      'en_dash'       => "\u2013",
      'ellipsis'      => "\u2026",
      'smart_quotes'  => true,
      'text_hint'     => 'off',
    }

    #Translate the hints to the methods.
    ANTIALIAS_OPTS = {
      nil        => 'subpixel',
      'best'     => 'subpixel',
      'good'     => 'gray',
      'fast'     => 'gray',
      'gray'     => 'gray',
      'subpixel' => 'subpixel'
    }

    def initialize(config_hash = DEFAULTS)
      @config_hash = config_hash
      @typographer = Args::Typographer.new(config_hash)
      normalize_antialias
    end

    # FIXME REMOVE THIS as part of refactoring
    # Delegate [] to our hash
    # @api private
    # def [](key)
    #   @config_hash[key]
    # end

    # Load the configuration file, if exists, overriding hardcoded defaults
    # @api private
    def self.load(file)
      yaml = {}
      if File.exists? file
        Squib::logger.info { "  using config: #{file}" }
        yaml = YAML.load_file(file) || {}
      end
      Conf.new(DEFAULTS.merge(yaml))
    end

    def to_s
      "Conf: #{@config_hash.to_s}"
    end

    def img_dir
      @config_hash['img_dir']
    end

    def text_hint
      @config_hash['text_hint']
    end

    def progress_bars
      @config_hash['progress_bars']
    end

    def typographer
      @typographer
    end

    def dir
      @config_hash['dir']
    end

    def prefix
      @config_hash['prefix']
    end

    def count_format
      @config_hash['count_format']
    end

    def antialias
      @config_hash['antialias']
    end

    def backend
      @config_hash['backend']
    end

    def custom_colors
      @config_hash['custom_colors']
    end

    private

    def normalize_antialias
      @config_hash['antialias'] = ANTIALIAS_OPTS[@config_hash['antialias'].downcase.strip]
    end

  end
end