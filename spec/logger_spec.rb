require 'spec_helper'

describe Squib.logger do
  it 'uses the custom format' do
    Squib.logger = nil
    oldstdout = $stdout
    $stdout = StringIO.new
    Squib::logger.warn 'Test warn'
    expect($stdout.string).to match /WARN: Test warn/
    $stdout = oldstdout
  end
end