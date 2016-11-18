require 'forwardable'
require 'yaml'
require_relative 'args/typographer'

module Squib
  USER_CONFIG = {}

  def configure(opts)
    str_hash = opts.inject({}) { |h, (k, v)| h[k.to_s] = v; h }
    USER_CONFIG.merge! str_hash
  end
  module_function :configure

  # @api private
  class Conf

    DEFAULTS = {
      'antialias'     => 'best',
      'backend'       => 'memory',
      'count_format'  => '%02d',
      'custom_colors' => {},
      'dir'           => '_output',
      'hint'          => :none,
      'img_dir'       => '.',
      'progress_bars' => false,
      'prefix'        => 'card_',
      'ldquote'       => "\u201C", # UTF8 chars
      'rdquote'       => "\u201D",
      'lsquote'       => "\u2018",
      'rsquote'       => "\u2019",
      'em_dash'       => "\u2014",
      'en_dash'       => "\u2013",
      'ellipsis'      => "\u2026",
      'smart_quotes'  => true,
      'text_hint'     => 'off',
      'warn_ellipsize' => true,
      'warn_png_scale' => true,
    }

    # Translate the hints to the methods.
    ANTIALIAS_OPTS = {
      nil        => 'subpixel',
      'best'     => 'subpixel',
      'good'     => 'gray',
      'fast'     => 'gray',
      'gray'     => 'gray',
      'subpixel' => 'subpixel'
    }

    def initialize(config_hash = DEFAULTS)
      @config_hash = config_hash.merge USER_CONFIG # programmatic overrides yml
      @typographer = Args::Typographer.new(config_hash)
      normalize_antialias
    end

    # Load the configuration file, if exists, overriding hardcoded defaults
    # @api private
    def self.load(file)
      yaml = {}
      if File.exists? file
        Squib::logger.info { "  using config: #{file}" }
        yaml = YAML.load_file(file) || {}
      end
      warn_unrecognized(yaml)
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

    def text_hint=(hint)
      @config_hash['text_hint'] = hint
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

    def warn_ellipsize?
      @config_hash['warn_ellipsize']
    end

    def warn_png_scale?
      @config_hash['warn_png_scale']
    end

    private

    def normalize_antialias
      @config_hash['antialias'] = ANTIALIAS_OPTS[@config_hash['antialias'].downcase.strip]
    end

    # Were there any unrecognized options in the config file?
    def self.warn_unrecognized(yaml)
      unrec = yaml.keys - DEFAULTS.keys
      if unrec.any?
        Squib::logger.warn "Unrecognized configuration option(s): #{unrec.join(',')}"
      end
    end

  end
end
