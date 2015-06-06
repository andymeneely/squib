require 'squib'
require 'spec_helper'

describe Squib::Conf do

  it 'parses the project template file just fine' do
    conf = Squib::Conf.load(project_template('config.yml'))
    expect(conf.backend).to eq(Squib::Conf::DEFAULTS['backend'])
  end

  it 'parses an empty file' do
    conf = Squib::Conf.load(conf('empty.yml'))
    expect(conf.backend).to eq(Squib::Conf::DEFAULTS['backend'])
  end

  it 'parses the sample custom config' do
    conf = Squib::Conf.load(sample_file('custom-config.yml'))
    expect(conf.progress_bars).to  be true
    expect(conf.text_hint).to      eq '#FF0000'
    expect(conf.custom_colors).to  eq({ 'foo' => '#ccc' })
    expect(conf.img_dir).to        eq 'customconfig-imgdir'
  end

  it 'normalizes antialias automatically' do
    expect(Squib::Conf::DEFAULTS['antialias']).to eq 'best'
    expect(Squib::Conf.new.antialias).to          eq 'subpixel'
  end

end
