#!/usr/bin/env ruby
require 'squib'

Squib::Deck.new do
  text str: 'Hello, World!'  
  save_png
end