require 'spec_helper'
require 'active_support'
require 'active_support/core_ext/string/inflections'

def documented_options(dsl_method)
  rst = doc_dsl_rst dsl_method.to_s.underscore
  options_rst = rst[/Options.+^+(.+)^+/m]
  includes = options_rst.scan(/\.\. include:: \/args\/(.+)\.rst/).flatten
  includes.each do |key|
    options_rst.gsub!(".. include:: /args/#{key}.rst", doc_args_rst(key))
  end
  opts = options_rst.lines.select { |line| line.match? /^[a-z]/ }
  opts.map { |o| o.strip.to_sym }
end
