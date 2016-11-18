require 'squib'
require 'spec_helper'

describe Squib::Conf do

  it 'parses the project template file just fine' do
    conf = Squib::Conf.load project_template('config.yml')
    expect(conf.backend).to eq(Squib::Conf::DEFAULTS['backend'])
  end

  it 'parses an empty file' do
    conf = Squib::Conf.load conf('empty.yml')
    expect(conf.backend).to eq(Squib::Conf::DEFAULTS['backend'])
  end

  it 'parses the sample custom config' do
    conf = Squib::Conf.load sample_file('custom-config.yml')
    expect(conf.progress_bars).to  be true
    expect(conf.text_hint).to      eq '#FF0000'
    expect(conf.custom_colors).to  eq({ 'foo' => '#ccc' })
    expect(conf.img_dir).to        eq 'customconfig-imgdir'
  end

  it 'normalizes antialias automatically' do
    expect(Squib::Conf::DEFAULTS['antialias']).to eq 'best'
    expect(Squib::Conf.new.antialias).to          eq 'subpixel'
  end

  it 'warns when the yml has an unrecognized option' do
    expect(Squib::logger).to receive(:warn).with('Unrecognized configuration option(s): unicorns')
    Squib::Conf.load conf('unrecognized.yml')
  end

  it 'helps Andy get full coverage with a test on to_s' do
    conf = Squib::Conf.load conf('empty.yml')
    expect(conf.to_s).to start_with 'Conf: '
  end

  it 'allows Squib.configure to override yml' do
    Squib.configure img_dir: 'color'
    c = Squib::Conf.load conf('basic.yml')
    expect(c.img_dir).to eq 'color'
    # reset our state to be nice
    Squib::USER_CONFIG.clear
  end

end
