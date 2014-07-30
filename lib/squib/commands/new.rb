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
    #   git commit -am "Starting my cool new game using Squib!"
    #
    # @api public
    class New

      # :nodoc:
      # @api private 
      def process(args)
        raise ArgumentError.new('Please specify a path.') if args.empty?

        new_project_path = File.expand_path(args.join(" "), Dir.pwd)
        template_path = File.expand_path('../project_template', File.dirname(__FILE__))

        FileUtils.mkdir_p new_project_path
        if !Dir["#{new_project_path}/**/*"].empty?
          $stderr.puts "#{new_project_path} exists and is not empty. Doing nothing and quitting."
        else
          Dir.chdir(new_project_path) do
            FileUtils.cp_r template_path + '/.', new_project_path
          end
        end
      end

    end
  end
end