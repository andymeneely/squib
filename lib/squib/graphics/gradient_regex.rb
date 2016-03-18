module Squib
  # @api private
  module Graphics
    STOPS = /   # used to capture the stops
      \s*         # leading whitespace is ok
      (\#?[\w]+)  # color
      @           # no spaces here
      (\d+\.?\d*) # offset number
    /x

    LINEAR_GRADIENT = /
      \( \s*      # coordinate 1
         (\d+\.?\d*) \s* # x1 number
         ,\s*            # whitespace after comma is ok
         (\d+\.?\d*) \s* # y1 number
      \)
      \s*        # space between coordinates is ok
      \( \s*      # coordinate 2
         (\d+\.?\d*) \s* # x2 number
         ,\s*            # whitespace after comma is ok
         (\d+\.?\d*) \s* # y2 number
      \)
      (#{STOPS})+ # stops
      \s*         # trailing whitespace is ok
    /x

    RADIAL_GRADIENT = /
      \( \s*      # coordinate 1
        (\d+\.?\d*) \s* # x1 number
        ,\s*            # whitespace after comma is ok
        (\d+\.?\d*) \s* # y1 number
        ,\s*            # whitespace after comma is ok
        (\d+\.?\d*) \s* # r1 number
      \)
      \s*         # space between coordinates is ok
      \( \s*      # coordinate 2
        (\d+\.?\d*) \s* # x2 number
        ,\s*            # whitespace after comma is ok
        (\d+\.?\d*) \s* # y2 number
        ,\s*            # whitespace after comma is ok
        (\d+\.?\d*) \s* # r2 number
      \)
      (#{STOPS})+ # stops
      \s*         # trailing whitespace is ok
    /x
  end
end
