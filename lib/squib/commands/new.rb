require 'fileutils'

module Squib
  # Squib's command-line options
  module Commands

    # Generate a new Squib project into a fresh directory.
    #
    # Provides conventions for using Git (you are using version control, right??).
    # Also provides some basic layout and config files to start from, along with templates for instructions and other notes you don't want to forget.
    #
    #
    # @example
    #   squib new foo-blasters
    #   cd foo-blasters
    #   ruby deck.rb
    #   git init
    #   git add .
    #   git commit -m "Starting my cool new game using Squib!"
    #
    # @api public
    class New

      # :nodoc:
      # @api private
      def process(args, advanced)
        raise empty_path_error if args.empty?

        new_project_path = File.expand_path(args.join(' '), Dir.pwd)

        FileUtils.mkdir_p new_project_path
        if !Dir["#{new_project_path}/**/*"].empty?
          $stderr.puts "#{new_project_path} exists and is not empty. Doing nothing and quitting."
        else
          Dir.chdir(new_project_path) do
            FileUtils.cp_r template_path(advanced) + '/.', new_project_path
          end
        end
        puts "Created basic Squib project in #{new_project_path}."
        puts advanced_message if advanced
      end

      def empty_path_error
        ArgumentError.new('Please specify a path.')
      end

      def template_path(advanced)
        path = case advanced
               when true
                 '../builtin/projects/advanced'
               else
                 '../builtin/projects/basic'
               end
        File.expand_path(path, File.dirname(__FILE__))
      end

      def advanced_message
        <<-EOS

This is the advanced layout designed for larger games. Everything is
organized into separate directories and the workflow is all based on
the Rakefile.

From within this directory, run `bundle install` to install extra
gems.

After that,  run `rake` to build. Check out the Rakefile for more.

Happy Squibbing! And best of luck with your game.
  -Andy (@andymeneely)

        EOS
      end

    end
  end
end
