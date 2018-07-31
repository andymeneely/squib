require 'spec_helper'

describe Squib::LayoutParser do

  it 'loads a normal layout with no extends' do
    layout = subject.load_layout(layout_file('no-extends.yml'))
    expect(layout).to eq({ 'frame' => {
            'x' => 38,
            'valign' => :middle,
            'str' => 'blah',
            'font' => 'Mr. Font',
            }
          }
        )
  end

  it 'loads with a single extends' do
    layout = subject.load_layout(layout_file('single-extends.yml'))
    expect(layout).to eq({ 'frame' => {
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
    layout = subject.load_layout(layout_file('pre-extends.yml'))
    expect(layout).to eq({ 'frame' => {
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
    layout = subject.load_layout(layout_file('single-level-multi-extends.yml'))
    expect(layout).to eq({ 'frame' => {
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
    layout = subject.load_layout(layout_file('multi-extends-single-entry.yml'))
    expect(layout).to eq({ 'aunt' => {
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
            'extends' => ['uncle', 'aunt'],
            'a' => 107, # my own
            'b' => 102, # from the younger aunt
            'c' => 103, # from aunt
            'x' => 108, # my own
            'y' => 105, # from uncle
            },
          }
        )
  end

  it 'applies multiple extends with relative operators' do
    layout = subject.load_layout(layout_file('multi-extends-operators.yml'))
    expect(layout).to eq({
      'socrates' => {
        'x' => 100,
      },
      'plato' => {
        'y' => 200,
      },
      'aristotle' => {
        'extends' => ['socrates', 'plato'],
        'x' => 150.0, # do the += 50 on socrates
        'y' => 200,
      },
    })
  end

  it 'applies multiple extends with relative operators on same key' do
    layout = subject.load_layout(layout_file('multi-extends-operators-same.yml'))
    expect(layout).to eq({
      'socrates' => {
        'x' => 100,
      },
      'plato' => {
        'x' => 200,
      },
      'aristotle' => {
        'extends' => ['socrates', 'plato'],
        'x' => 250, # do the += 50 from plato, NOT socrates
      },
    })
  end

  it 'applies multiple extends with relative operators with ' do
    layout = subject.load_layout(layout_file('multi-extends-operators-complex.yml'))
    expect(layout).to eq({
      'socrates' => {
        'x' => 100,
        'y' => 1000,
      },
      'plato' => {
        'y' => 2000,
      },
      'aristotle' => {
        'extends' => ['socrates', 'plato'],
        'x' => 130.0, # 0.1in -> 30.0, so 100 + 30 = 130.0
        'y' => 2018.0, # From Plato, 2000 + 18
      },
    })
  end

  it 'applies multi-level extends' do
    layout = subject.load_layout(layout_file('multi-level-extends.yml'))
    expect(layout).to eq({ 'frame' => {
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
    expect { subject.load_layout(file)}
      .to raise_error(RuntimeError, 'Invalid layout: circular extends with \'a\'')
  end

  it 'fails on a easy-circular extends' do
    file = layout_file('easy-circular-extends.yml')
    expect { subject.load_layout(file)}
      .to raise_error(RuntimeError, 'Invalid layout: circular extends with \'a\'')
  end

  it 'hard on a easy-circular extends' do
    file = layout_file('hard-circular-extends.yml')
    expect { subject.load_layout(file)}
      .to raise_error(RuntimeError, 'Invalid layout: circular extends with \'a\'')
  end

  it 'redefines keys on multiple layouts' do
    a = layout_file('multifile-a.yml')
    b = layout_file('multifile-b.yml')
    layout = subject.load_layout([a, b])
    expect(layout).to eq({
        'title'    => { 'x' => 300 },
        'subtitle' => { 'x' => 200 },
        'desc'     => { 'x' => 400 }
        })
  end

  it 'evaluates extends on each file first' do
    a = layout_file('multifile-extends-a.yml')
    b = layout_file('multifile-extends-b.yml')
    layout = subject.load_layout([a, b])
    expect(layout).to eq({
        'grandparent' => { 'x' => 100 },
        'parent_a'    => { 'x' => 110, 'extends' => 'grandparent' },
        'parent_b'    => { 'x' => 130, 'extends' => 'grandparent' },
        'child_a'     => { 'x' => 113, 'extends' => 'parent_a' },
        'child_b'     => { 'x' => 133, 'extends' => 'parent_b' }
        })
  end

  it 'loads nothing on an empty layout file' do
    layout = subject.load_layout(layout_file('empty.yml'))
    expect(layout).to eq({})
  end

  it 'handles extends on a rule with no args' do
    layout = subject.load_layout(layout_file('empty-rule.yml'))
    expect(layout).to eq({
      'empty' => nil
    })
  end

  it 'logs an error when a file is not found' do
    expect(Squib.logger).to receive(:error).once
    subject.load_layout('yeti')
  end

  it 'freaks out if you extend something doesn\'t exist' do
    expect(Squib.logger)
      .to receive(:error)
      .with("Processing layout: 'verbal' attempts to extend a missing 'kaisersoze'")
    layout = subject.load_layout(layout_file('extends-nonexists.yml'))
    expect(layout).to eq({
      'verbal' => {
          'font_size' => 25,
          'extends' => 'kaisersoze'
        }
      })
  end

  it 'does unit conversion when extending' do
    layout = subject.load_layout(layout_file('extends-units.yml'))
    expect(layout).to eq({
      'parent' => { 'x' => '0.5in', 'y' => '1in'},
      'child'  => { 'x' => 450.0, 'y' => 150.0, 'extends' => 'parent' },
    })
  end

  it 'does unit conversion on non-300 dpis' do
    parser = Squib::LayoutParser.new(100)
    layout = parser.load_layout(layout_file('extends-units.yml'))
    expect(layout).to eq({
      'parent' => { 'x' => '0.5in', 'y' => '1in'},
      'child'  => { 'x' => 150.0, 'y' => 50.0, 'extends' => 'parent' },
    })
  end

  it 'does mixed unit conversion when extending' do
    layout = subject.load_layout(layout_file('extends-units-mixed.yml'))
    expect(layout).to eq({
      'parent' => {
        'x' => 100, 'y' => '1in',
        'width' => 200, 'height' => '1cm' },
      'child'  => {
        'x' => 400.0, 'y' => 181.8897639,
        'width' => 300.0, 'height' => 29.527559025,
        'extends' => 'parent' },
    })
  end

  it 'loads progressively on multiple calls' do
    a = layout_file('multifile-a.yml')
    b = layout_file('multifile-b.yml')
    layout = subject.load_layout(a)
    layout = subject.load_layout(b, layout)
    expect(layout).to eq({
        'title'    => { 'x' => 300 },
        'subtitle' => { 'x' => 200 },
        'desc'     => { 'x' => 400 }
        })
  end

end
