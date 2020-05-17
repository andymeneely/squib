require 'set'

module Squib

  # DSL method. See http://squib.readthedocs.io
  def enable_build_globally group
    groups = (ENV['SQUIB_BUILD'] ||= '').split(',')
    ENV['SQUIB_BUILD'] = (groups << group).uniq.join(',')
  end
  module_function :enable_build_globally

  # DSL method. See http://squib.readthedocs.io
  def disable_build_globally group
    groups = (ENV['SQUIB_BUILD'] ||= '').split(',')
    groups.delete(group.to_s)
    ENV['SQUIB_BUILD'] = groups.uniq.join(',')
  end
  module_function :disable_build_globally

  class Deck

    # DSL method. See http://squib.readthedocs.io
    def build grp = :all, &block
      raise 'Please provide a block' unless block_given?
      block.yield if build_groups.include? grp
    end

    # DSL method. See http://squib.readthedocs.io
    def enable_build grp
      build_groups # make sure it's initialized
      @build_groups << grp
    end

    # DSL method. See http://squib.readthedocs.io
    def disable_build grp
      build_groups # make sure it's initialized
      @build_groups.delete grp
    end

    # DSL method. See http://squib.readthedocs.io
    def build_groups
      @build_groups ||= Set.new.add(:all)
    end

    # Not a DSL method, but initialized from Deck.new
    def enable_groups_from_env!
      return if ENV['SQUIB_BUILD'].nil?
      ENV['SQUIB_BUILD'].split(',').each do |grp|
        enable_build grp.strip.to_sym
      end
    end

  end
end
