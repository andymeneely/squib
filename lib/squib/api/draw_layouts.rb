module Squib
  class Deck

    # DSL method. See http://squib.readthedocs.io
    def draw_layouts(opts = {})
      pattern = opts[:pattern]
      layout.each do |key, value|
        if /#{pattern}/ =~ key
          if value['type'] && self.respond_to?(value['type'])
            new_opts = opts.clone
            new_opts[:layout] = key.to_sym
            self.public_send(value['type'],new_opts)
          end
        end
      end
    end

  end
end
