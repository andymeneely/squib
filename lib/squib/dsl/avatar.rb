require 'mechanize'
require_relative '../errors_warnings/warn_unexpected_params'
require_relative '../args/card_range'
require_relative '../args/paint'
require_relative '../args/scale_box'
require_relative '../args/transform'
require_relative '../args/svg_special'

module Squib
  class Deck
    def avatar(opts = {})
      DSL::Avatar.new(self, __callee__).run(opts)
    end
  end

  module DSL
    # Add an avatar for placeholder art in your games
    # using https://avatars.dicebear.com/. The image will
    # be downloaded to your configured image directory if
    # it doesn't already exist.
    #
    # Library can be male, female, human, identicon, initials,
    # bottts, avataaars, jdenticon, gridy or micah.
    #
    # Seed can be any random string
    #
    # Example:
    #   avatar library: 'micah', seed: '1234'
    class Avatar
      include WarnUnexpectedParams
      attr_reader :dsl_method, :deck

      def initialize(deck, dsl_method)
        @deck = deck
        @dsl_method = dsl_method
      end

      def self.accepted_params
        %i[
          library seed
          x y width height
          blend mask
          crop_x crop_y crop_width crop_height
          crop_corner_radius crop_corner_x_radius crop_corner_y_radius
          flip_horizontal flip_vertical angle
          id force_id data
          range layout
          placeholder
        ]
      end

      def run(opts)
        warn_if_unexpected opts
        Dir.chdir(deck.img_dir) do
          defaults = { library: 'avataaars' }
          options = defaults.merge opts

          # Extract the default svg options
          range = Args.extract_range opts, deck
          svg_args = Args.extract_svg_special opts, deck
          paint = Args.extract_paint opts, deck
          box   = Args.extract_scale_box opts, deck
          trans = Args.extract_transform opts, deck

          deck.progress_bar.start('Loading Avatar(s)', range.size) do |bar|
            range.each do |i|
              library = options[:library]
              seed = options[:seed]
              next if seed.nil?

              file = "avatar-#{library}-#{seed}.svg"

              # Check if we need to download the image
              unless File.exist?(file)
                agent = Mechanize.new
                agent.follow_meta_refresh = true
                agent.keep_alive = false
                agent.history.max_size = 10

                response = agent.get_file("https://avatars.dicebear.com/api/#{library}/#{seed}.svg")
                response = response.encode('ascii-8bit').force_encoding('utf-8')

                File.open(file, 'w') { |f| f.write(response) }
              end

              deck.cards[i].svg(file, svg_args[i], box[i], paint[i], trans[i])
              bar.increment
            end
          end
        end
      end
    end
  end
end
