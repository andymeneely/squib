require 'spec_helper'

describe Squib::Template do
  it 'loads a template' do
    tmpl = Squib::Template.load(template_file('basic.yml'), 100)
    expect(tmpl.sheet_width).to eq(850)
    expect(tmpl.sheet_height).to eq(1100)
    expect(tmpl.card_width).to eq(250)
    expect(tmpl.card_height).to eq(350)
    expect(tmpl.dpi).to eq(100)
    expect(tmpl.crop_line_overlay).to eq(
      Squib::Template::DEFAULTS['crop_line']['overlay']
    )
    expect(tmpl.crop_lines).to eq([])
    expect(tmpl.cards).to eq([{ 'x' => 50, 'y' => 100, 'rotate' => 0 }])
  end
end
