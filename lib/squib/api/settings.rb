module Squib
  class Deck

    # DSL method. See http://squib.readthedocs.io
    def hint(text: :off)
      conf.text_hint = text
    end

    # DSL method. See http://squib.readthedocs.io
    def set(opts = {})
      raise 'DEPRECATED: As of v0.7 img_dir is no longer supported in "set". Use config.yml instead.' if opts.key? :img_dir
      @font = (opts[:font] == :default) ? Squib::DEFAULT_FONT : opts[:font]
    end

    # DSL method. See http://squib.readthedocs.io
    def use_layout(file: 'layout.yml')
      @layout = LayoutParser.new(@dpi).load_layout(file, @layout)
    end

  end
end
