module Squib::Args::DirValidator

  def ensure_dir_created(dir)
    unless Dir.exist?(dir)
      Squib.logger.warn "Dir '#{dir}' does not exist, creating it."
      FileUtils.mkdir_p dir
    end
    return dir
  end

end
