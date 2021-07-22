# require 'squib'
require_relative '../../lib/squib'

# Per issue #334, sometimes Pango doesn't find the font file you want
# Pango requires fonts to be installed on the system, but sometimes the
# font name is not obvious. e.g. "Foo Regular" might be actually named "Foo"
# Use these methods to debug this problem

# Usually you would just run this method to see what fonts are installed
# This is commented out to make our test cases
# Squib.print_system_fonts

Squib.system_fonts.include? 'Open Sans' # checks if we have Open Sans installed
# Note: does nothing since it's just a check
