require 'rainbow/refinement'

module Squib::ErrorContext
  using Rainbow # we can colorize strings now!

  # When we throw an error, we want to be able to find and report:
  #  (a) the DSL method we called, e.g. 'background'
  #  (b) the line number from the user's source file
  def error_context
    "in Squib DSL method #{dsl_method.to_s.aliceblue} from #{user_loc}"
  end
end
