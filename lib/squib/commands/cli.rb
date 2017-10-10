require 'mercenary'
require_relative 'make_sprue'
require_relative 'new'

module Squib
  class CLI

    def run
      Mercenary.program(:squib) do |p|
        p.version Squib::VERSION
        p.description 'A Ruby DSL for prototyping card games'
        p.syntax 'squib <subcommand> [options]'

        p.command(:new) do |c|
          c.syntax 'new PATH'
          c.description 'Creates a new basic Squib project scaffolding in PATH. Must be a new directory or already empty.'

          c.option 'advanced', '--advanced', 'Create the advanced layout'

          c.action do |args, options|
            advanced = options.key? 'advanced'
            Squib::Commands::New.new.process(args, advanced)
          end
        end

        p.command(:make_sprue) do |c|
          c.syntax 'make_sprue'
          c.description 'Creates a sprue definition file.'

          c.action do |args, options|
            Squib::Commands::MakeSprue.new.process(args)
          end
        end

      end
    end

  end
end
