require 'spec_helper'

describe Squib::LayoutParser do

  it 'loads a normal layout with no extends' do
    layout = Squib::LayoutParser.load_layout(layout_file('no-extends.yml'))
    expect(layout).to eq({'frame' => {
            'x' => 38,
            'valign' => :middle,
            'str' => 'blah',
            'font' => 'Mr. Font',
            }
          }
        )
  end

  it 'loads with a single extends' do
    layout = Squib::LayoutParser.load_layout(layout_file('single-extends.yml'))
    expect(layout).to eq({'frame' => {
            'x' => 38,
            'y' => 38,
            },
          'title' => {
            'extends' => 'frame',
            'x' => 38,
            'y' => 50,
            'width' => 100,
            }
          }
        )
  end

  it 'applies the extends regardless of order' do
    layout = Squib::LayoutParser.load_layout(layout_file('pre-extends.yml'))
    expect(layout).to eq({'frame' => {
            'x' => 38,
            'y' => 38,
            },
          'title' => {
            'extends' => 'frame',
            'x' => 38,
            'y' => 50,
            'width' => 100,
            }
          }
        )
  end

  it 'applies the single-level extends multiple times' do
    layout = Squib::LayoutParser.load_layout(layout_file('single-level-multi-extends.yml'))
    expect(layout).to eq({'frame' => {
            'x' => 38,
            'y' => 38,
            },
          'title' => {
            'extends' => 'frame',
            'x' => 38,
            'y' => 50,
            'width' => 100,
            },
          'title2' => {
            'extends' => 'frame',
            'x' => 75,
            'y' => 150,
            'width' => 150,
            },
          }
        )
  end

  it 'applies multiple extends in a single rule' do
    layout = Squib::LayoutParser.load_layout(layout_file('multi-extends-single-entry.yml'))
    expect(layout).to eq({'aunt' => {
            'a' => 101,
            'b' => 102,
            'c' => 103,
            },
          'uncle' => {
            'x' => 104,
            'y' => 105,
            'b' => 106,
            },
          'child' => {
            'extends' => ['uncle','aunt'],
            'a' => 107, # my own
            'b' => 102, # from the younger aunt
            'c' => 103, # from aunt
            'x' => 108, # my own
            'y' => 105, # from uncle
            },
          }
        )
  end

  it 'applies multi-level extends' do
    layout = Squib::LayoutParser.load_layout(layout_file('multi-level-extends.yml'))
    expect(layout).to eq({'frame' => {
            'x' => 38,
            'y' => 38,
            },
          'title' => {
            'extends' => 'frame',
            'x' => 38,
            'y' => 50,
            'width' => 100,
            },
          'subtitle' => {
            'extends' => 'title',
            'x' => 38,
            'y' => 150,
            'width' => 100,
            },
          }
        )
  end

  it 'fails on a self-circular extends' do
    file = layout_file('self-circular-extends.yml')
    expect { Squib::LayoutParser.load_layout(file) }
      .to raise_error(RuntimeError, 'Invalid layout: circular extends with \'a\'')
  end

  it 'fails on a easy-circular extends' do
    file = layout_file('easy-circular-extends.yml')
    expect { Squib::LayoutParser.load_layout(file) }
      .to raise_error(RuntimeError, 'Invalid layout: circular extends with \'a\'')
  end

  it 'hard on a easy-circular extends' do
    file = layout_file('hard-circular-extends.yml')
    expect { Squib::LayoutParser.load_layout(file) }
      .to raise_error(RuntimeError, 'Invalid layout: circular extends with \'a\'')
  end

  it 'redefines keys on multiple layouts' do
    a = layout_file('multifile-a.yml')
    b = layout_file('multifile-b.yml')
    layout = Squib::LayoutParser.load_layout([a, b])
    expect(layout).to eq({
        'title'    => { 'x' => 300 },
        'subtitle' => { 'x' => 200 },
        'desc'     => { 'x' => 400 }
        })
  end

  it 'evaluates extends on each file first' do
    a = layout_file('multifile-extends-a.yml')
    b = layout_file('multifile-extends-b.yml')
    layout = Squib::LayoutParser.load_layout([a, b])
    expect(layout).to eq({
        'grandparent' => { 'x' => 100 },
        'parent_a'    => { 'x' => 110, 'extends' => 'grandparent' },
        'parent_b'    => { 'x' => 130, 'extends' => 'grandparent' },
        'child_a'     => { 'x' => 113, 'extends' => 'parent_a' },
        'child_b'     => { 'x' => 133, 'extends' => 'parent_b' }
        })
  end

  it 'loads nothing on an empty layout file' do
    layout = Squib::LayoutParser.load_layout(layout_file('empty.yml'))
    expect(layout).to eq({})
  end

  it 'handles extends on a rule with no args' do
    layout = Squib::LayoutParser.load_layout(layout_file('empty-rule.yml'))
    expect(layout).to eq({
      'empty' => nil
    })
  end

  it 'logs an error when a file is not found' do
    expect(Squib.logger).to receive(:error).once
    Squib::LayoutParser.load_layout('yeti')
  end

  it 'freaks out if you extend something doesn\'t exist' do
    expect(Squib.logger)
      .to receive(:error)
      .with("Processing layout: 'verbal' attempts to extend a missing 'kaisersoze'")
    layout = Squib::LayoutParser.load_layout(layout_file('extends-nonexists.yml'))
    expect(layout).to eq({
      'verbal'  => {
          'font_size' => 25,
          'extends' => 'kaisersoze'
        }
      })
  end

  it 'loads progressively on multiple calls' do
    a = layout_file('multifile-a.yml')
    b = layout_file('multifile-b.yml')
    layout = Squib::LayoutParser.load_layout(a)
    layout = Squib::LayoutParser.load_layout(b, layout)
    expect(layout).to eq({
        'title'    => { 'x' => 300 },
        'subtitle' => { 'x' => 200 },
        'desc'     => { 'x' => 400 }
        })
  end

end
