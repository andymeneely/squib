module Squib
  #@api private
  module Args
    # Internal class for handling arguments
    #@api private
    class VendorArgs

      def self.base_options (card)
      	  base_opts = YAML.load_file("#{File.dirname(__FILE__)}/../vendor/base.yml")
        if base_opts.keys.include?(card)
          return base_opts[card]
        else
          raise ArgumentError.new "Card type \"#{card.to_s}\" is not supported."
        end
      end

      def self.vendor_options (card, vendor)

          vendor_opts = YAML.load_file("#{File.dirname(__FILE__)}/../vendor/#{vendor}.yml")
          if  vendor_opts['items'].include? card
            return vendor_opts['specs']
          else
            Squib.logger.warn "Card type \"#{card.to_s}\" is not supported by vendor \"#{vendor}.\"  Using defaults."
            return nil
          end

        rescue SystemCallError
          Squib::logger.warn "Vendor \"#{vendor}\" not found.  Using defaults."
          return nil
      	end

    end
  end
end
