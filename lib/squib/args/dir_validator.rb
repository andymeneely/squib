module Squib
  # @api private
  module Args
    module DirValidator

      def ensure_dir_created(dir)
        unless Dir.exists?(dir)
          Squib.logger.warn "Dir '#{dir}' does not exist, creating it."
          FileUtils.mkdir_p dir
        end
        return dir
      end

    end
  end
end
