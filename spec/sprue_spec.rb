require 'spec_helper'
require 'squib/sprues/sprue'

describe Squib::Sprue do
  it 'loads a sprue' do
    tmpl = Squib::Sprue.load(sprue_file('basic.yml'), 100)
    expect(tmpl.sheet_width).to eq(850)
    expect(tmpl.sheet_height).to eq(1100)
    expect(tmpl.card_width).to eq(250)
    expect(tmpl.card_height).to eq(350)
    expect(tmpl.dpi).to eq(100)
    expect(tmpl.crop_line_overlay).to eq(
      Squib::Sprue::DEFAULTS['crop_line']['overlay']
    )
    expect(tmpl.crop_lines).to eq([])
    expect(tmpl.cards).to eq([{ 'x' => 50, 'y' => 100, 'rotate' => 0 }])
  end

  it 'loads from the default templates if none exists' do
    tmpl = Squib::Sprue.load('a4_poker_card_9up.yml', 100)
    expect(tmpl.sheet_width).to eq(826.7716527)
    expect(tmpl.sheet_height).to eq(1169.2913373899999)
    expect(tmpl.card_width).to eq(248.03149580999997)
    expect(tmpl.card_height).to eq(346.45669256)
    expect(tmpl.dpi).to eq(100)

    expect(tmpl.crop_lines.length).to eq(8)
    expect(tmpl.crop_lines.map { |line| line['type'] }).to eq(
      %i[
        vertical vertical vertical vertical
        horizontal horizontal horizontal horizontal
      ]
    )
    expect(tmpl.crop_lines.map { |line| line['line'].x1 }).to eq(
      [
        41.338582635, 289.370078445, 537.401574255, 785.433070065,
        0, 0, 0, 0
      ]
    )
    expect(tmpl.crop_lines.map { |line| line['line'].x2 }).to eq(
      [
        41.338582635, 289.370078445, 537.401574255, 785.433070065,
        826.7716527, 826.7716527, 826.7716527, 826.7716527
      ]
    )
    expect(tmpl.crop_lines.map { |line| line['line'].y1 }).to eq(
      [
        0, 0, 0, 0,
        39.3700787, 385.82677126, 732.28346382, 1078.74015638
      ]
    )
    expect(tmpl.crop_lines.map { |line| line['line'].y2 }).to eq(
      [
        1169.2913373899999, 1169.2913373899999, 1169.2913373899999,
        1169.2913373899999,
        39.3700787, 385.82677126, 732.28346382, 1078.74015638
      ]
    )

    expect(tmpl.cards.length).to eq(9)
    expect(tmpl.cards.map { |card| card['x'] }).to eq(
      [41.338582635, 289.370078445, 537.401574255] * 3
    )
    expect(tmpl.cards.map { |card| card['y'] }).to eq(
      [
        39.3700787, 39.3700787, 39.3700787,
        385.82677126, 385.82677126, 385.82677126,
        732.28346382, 732.28346382, 732.28346382
      ]
    )

    expect(tmpl.margin).to eq(
      left: 40.3543306675,
      right: 786.4173220325,
      top: 38.3858267325,
      bottom: 1079.7244083475
    )
  end

  it 'loads a template with the coordinates specifying the middle of cards' do
    tmpl = Squib::Sprue.load(sprue_file('card_center_coord.yml'), 100)
    expect(tmpl.sheet_width).to eq(850)
    expect(tmpl.sheet_height).to eq(1100)
    expect(tmpl.card_width).to eq(200)
    expect(tmpl.card_height).to eq(300)
    expect(tmpl.dpi).to eq(100)

    expect(tmpl.cards.length).to eq(8)
    expect(tmpl.cards.map { |card| card['x'] }).to eq(
      [25.0, 225.0, 425.0, 625.0] * 2
    )
    expect(tmpl.cards.map { |card| card['y'] }).to eq(
      [100.0, 100.0, 100.0, 100.0, 400.0, 400.0, 400.0, 400.0]
    )
  end

  it 'loads a template with customized crop lines' do
    tmpl = Squib::Sprue.load(sprue_file('custom_crop_lines.yml'), 100)
    expect(tmpl.sheet_width).to eq(850)
    expect(tmpl.sheet_height).to eq(1100)
    expect(tmpl.card_width).to eq(200)
    expect(tmpl.card_height).to eq(300)
    expect(tmpl.dpi).to eq(100)
    expect(tmpl.crop_line_overlay).to eq(:overlay_on_cards)

    expect(tmpl.crop_lines.length).to eq(6)
    expect(tmpl.crop_lines.map { |line| line['type'] }).to eq(
      %i[horizontal horizontal horizontal horizontal horizontal vertical]
    )
    expect(tmpl.crop_lines.map { |line| line['line'].x1 }).to eq(
      [0, 0, 0, 0, 0, 600]
    )
    expect(tmpl.crop_lines.map { |line| line['line'].x2 }).to eq(
      [850, 850, 850, 850, 850, 600]
    )
    expect(tmpl.crop_lines.map { |line| line['line'].y1 }).to eq(
      [100, 200, 300, 400, 500, 0]
    )
    expect(tmpl.crop_lines.map { |line| line['line'].y2 }).to eq(
      [100, 200, 300, 400, 500, 1100]
    )
    expect(tmpl.crop_lines.map { |line| line['style_desc'] }).to eq(
      %i[dashed dashed dotted dashed solid dashed]
    )
    expect(tmpl.crop_lines.map { |line| line['width'] }).to eq(
      [10, 20, 10, 10, 30, 10]
    )
    expect(tmpl.crop_lines.map { |line| line['color'] }).to eq(
      ['pink', 'pink', 'pink', '#ff0000', 'blue', 'pink']
    )
  end

  it 'loads a template with rotated cards' do
    tmpl = Squib::Sprue.load(sprue_file('card_rotation.yml'), 100)
    expect(tmpl.sheet_width).to eq(850)
    expect(tmpl.sheet_height).to eq(1100)
    expect(tmpl.card_width).to eq(250)
    expect(tmpl.card_height).to eq(350)
    expect(tmpl.dpi).to eq(100)

    expect(tmpl.cards.length).to eq(6)
    expect(tmpl.cards.map { |card| card['rotate'] }).to eq(
      [0.5 * Math::PI, 1.5 * Math::PI, Math::PI, 1, Math::PI / 3, 1.25]
    )
  end

  it 'fails when sheet_width is not defined' do
    expect do
      Squib::Sprue.load(sprue_file('fail_no_sheet_width.yml'), 100)
    end.to raise_error(
      Squib::Sprues::InvalidSprueDefinition,
      include('"sheet_width" is not a String matching /^(\d*[.])?\d+(in|cm|mm)$/')
    )
  end

  it 'fails when sheet_height is not defined' do
    expect do
      Squib::Sprue.load(sprue_file('fail_no_sheet_height.yml'), 100)
    end.to raise_error(
      Squib::Sprues::InvalidSprueDefinition,
      include('"sheet_height" is not a String matching /^(\d*[.])?\d+(in|cm|mm)$/')
    )
  end

  it 'fails when card_width is not defined' do
    expect do
      Squib::Sprue.load(sprue_file('fail_no_card_width.yml'), 100)
    end.to raise_error(
      Squib::Sprues::InvalidSprueDefinition,
      include('"card_width" is not a String matching /^(\d*[.])?\d+(in|cm|mm)$/')
    )
  end

  it 'fails when card_height is not defined' do
    expect do
      Squib::Sprue.load(sprue_file('fail_no_card_height.yml'), 100)
    end.to raise_error(
      Squib::Sprues::InvalidSprueDefinition,
      include('"card_height" is not a String matching /^(\d*[.])?\d+(in|cm|mm)$/')
    )
  end
end
