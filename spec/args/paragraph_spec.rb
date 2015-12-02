require 'spec_helper'
require 'squib/args/paragraph'
require 'squib/constants'

describe Squib::Args::Paragraph do
  subject(:para) { Squib::Args::Paragraph.new('FooFont 32') }

  context 'str validator' do
    it 'converts everything to string' do
      para.load!( {str: 5} )
      expect(para.str).to eq ['5']
    end
  end

  context 'font validator' do
    it 'uses deck font by default' do
      para.load!( {} )
      expect(para.font).to eq ['FooFont 32']
    end

    it 'uses system default font when deck font is :default' do
      para = Squib::Args::Paragraph.new(:default)
      para.load!( {} )
      expect(para.font).to eq [Squib::DEFAULT_FONT]
    end

    it 'uses specified font when given' do
      para.load!( {font: 'MyFont 8'})
      expect(para.font).to eq ['MyFont 8']
    end
  end

  context 'align validator' do
    it 'converts to pango left' do
      para.load!( { align: :left } )
      expect(para.align).to eq [Pango::ALIGN_LEFT]
    end

    it 'converts to pango right' do
      para.load!( { align: :RIGHT } )
      expect(para.align).to eq [Pango::ALIGN_RIGHT]
    end

    it 'converts to pango center' do
      para.load!( { align: 'center' } )
      expect(para.align).to eq [Pango::ALIGN_CENTER]
    end

    it 'raises an exception on anything else' do
      expect { para.load!( { align: 'foo' } ) }.to raise_error(ArgumentError, 'align must be one of: center, left, right')
    end
  end

  context 'wrap validator' do
    it 'converts to pango wrap word' do
      para.load!( { wrap: 'word'} )
      expect(para.wrap).to eq [Pango::WRAP_WORD]
    end

    it 'converts to pango wrap char' do
      para.load!( { wrap: 'WORD_ChAr'} )
      expect(para.wrap).to eq [Pango::WRAP_WORD_CHAR]
    end

    it 'converts to pango wrap char on true' do
      para.load!( { wrap: true} )
      expect(para.wrap).to eq [Pango::WRAP_WORD_CHAR]
    end

    it 'converts to pango wrap char with false' do
      para.load!( { wrap: false} )
      expect(para.wrap).to eq [Pango::WRAP_CHAR]
    end

    it 'raises an exception on anything else' do
      expect { para.load!( {wrap: 'foo' }) }.to raise_error(ArgumentError, 'wrap must be one of: word, char, word_char, true, or false')
    end
  end

  context 'ellipsize validator' do
    it 'converts to pango on none and false' do
      para.load!( { ellipsize: 'none'} )
      expect(para.ellipsize).to eq [Pango::Layout::ELLIPSIZE_NONE]
    end

    it 'converts to pango with start' do
      para.load!( { ellipsize: :StArt} )
      expect(para.ellipsize).to eq [Pango::Layout::ELLIPSIZE_START]
    end

    it 'converts to pango middle' do
      para.load!( { ellipsize: 'middle'} )
      expect(para.ellipsize).to eq [Pango::Layout::ELLIPSIZE_MIDDLE]
    end

    it 'converts to pango end' do
      para.load!( { ellipsize: 'END'} )
      expect(para.ellipsize).to eq [Pango::Layout::ELLIPSIZE_END]
    end

    it 'raises an exception on anything else' do
      expect { para.load!( {ellipsize: 'foo' }) }.to raise_error(ArgumentError, 'ellipsize must be one of: none, start, middle, end, true, or false')
    end
  end

  context 'justify validator' do
    it 'allows nil' do
      para.load!( { justify: nil} )
      expect(para.justify).to eq [nil]
    end

    it 'can be true' do
      para.load!( { justify: true} )
      expect(para.justify).to eq [true]
    end

    it 'can be false' do
      para.load!( { justify: false} )
      expect(para.justify).to eq [false]
    end

    it 'raises an exception on anything else' do
      expect { para.load!( {justify: 'false' }) }.to raise_error(ArgumentError, 'justify must be one of: nil, true, or false')
    end
  end

  context 'spacing validator' do
    it 'allows nil' do
      para.load!( { spacing: nil} )
      expect(para.spacing).to eq [nil]
    end
    it 'is converted to Pango space' do
      para.load!( { spacing: 519} )
      expect(para.spacing).to eq [Pango::SCALE * 519.0]
    end

    it 'raises an exception if not a float' do
      expect { para.load!( {spacing: /foo/ }) }.to raise_error(ArgumentError, 'spacing must be a number or nil')
    end
  end

  context 'valign validator' do
    it 'converts top' do
      para.load!( { valign: :top} )
      expect(para.valign).to eq ['top']
    end

    it 'raises an exception if not one of the three' do
      expect { para.load!( {valign: 'foo' }) }.to raise_error(ArgumentError, 'valign must be one of: top, middle, bottom')
    end
  end

end