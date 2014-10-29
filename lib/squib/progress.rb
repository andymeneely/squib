require 'ruby-progressbar'

module Squib

  # :nodoc:
  # @api private
  class DoNothing
    def increment
    end

    def finish
    end
  end

  # A facade that handles (or doesn't) the progress bar on the console
  #
  # :nodoc:
  # @api private
  class Progress
    attr_accessor :enabled

    def initialize(enabled)
      @enabled = enabled
    end

    def start(title='', total=100, &block)
      if @enabled
        @bar = ProgressBar.create(title: title, total: total, format: '%t <%B> %p%% %a')
        yield(@bar)
        @bar.finish
      else
        yield(Squib::DoNothing.new)
      end
    end
  end


end
