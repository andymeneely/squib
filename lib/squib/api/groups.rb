require 'set'

module Squib

  # An idea for later...
  # def enable_group_env group
  #   ENV['SQUIB_BUILD'] ||= ''
  #   ENV['SQUIB_BUILD'] += ','
  #   ENV['SQUIB_BUILD'] += group
  # end
  # module_function :enable_group_env

  class Deck

    # DSL method. See http://squib.readthedocs.org
    def build grp = :all, &block
      raise 'Please provide a block' unless block_given?
      block.yield if build_groups.include? grp
    end

    # DSL method. See http://squib.readthedocs.org
    def enable_build grp
      build_groups # make sure it's initialized
      @build_groups << grp
    end

    # DSL method. See http://squib.readthedocs.org
    def disable_build grp
      build_groups # make sure it's initialized
      @build_groups.delete grp
    end

    # DSL method. See http://squib.readthedocs.org
    def build_groups
      @build_groups ||= Set.new.add(:all)
    end

    # Not a DSL method, but initialized from Deck.new
    def enable_groups_from_env!
      return if ENV['SQUIB_BUILD'].nil?
      ENV['SQUIB_BUILD'].split(',').each do |grp|
        enable_group grp.strip.to_sym
      end
    end

  end
end
