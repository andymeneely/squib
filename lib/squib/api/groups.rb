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

    # See official API docs
    def group grp = :all, &block
      raise 'Please provide a block' unless block_given?
      block.yield if groups.include? grp
    end

    # See official API docs
    def enable_group grp
      groups # make sure it's initialized
      @build_groups << grp
    end

    # See official API docs
    def disable_group grp
      groups # make sure it's initialized
      @build_groups.delete grp
    end

    # See official API docs
    def groups
      @build_groups ||= Set.new.add(:all)
    end

    # See official API docs
    def enable_groups_from_env!
      return if ENV['SQUIB_BUILD'].nil?
      ENV['SQUIB_BUILD'].split(',').each do |grp|
        enable_group grp.strip.to_sym
      end
    end

  end
end
