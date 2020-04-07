require 'spec_helper'
require 'squib/args/box'

describe Squib::Args::SvgSpecial do
  subject(:svgargs) { Squib::Args::SvgSpecial.new }

   context :id do

     it 'appends # to ids' do
       args = { id: '123' }
       svgargs.load!(args, expand_by: 1)
       expect(svgargs).to have_attributes(id: ['#123'])
     end

     it 'does not appends # if one is there' do
       args = { id: '#1234' }
       svgargs.load!(args, expand_by: 1)
       expect(svgargs).to have_attributes(id: ['#1234'])
     end

     it 'is nil if empty' do
       args = { id: '' }
       svgargs.load!(args, expand_by: 1)
       expect(svgargs).to have_attributes(id: [nil])
     end

     it 'is nil if empty' do
       args = { id: nil }
       svgargs.load!(args, expand_by: 1)
       expect(svgargs).to have_attributes(id: [nil])
     end

   end

   context :force_id do

     it 'makes render true sometimes' do
       args = { id: '1', force_id: true }
       svgargs.load!(args, expand_by: 1)
       expect(svgargs.render?(0)).to be true
     end

     it 'makes render false sometimes' do
       args = { id: '', force_id: true }
       svgargs.load!(args, expand_by: 1)
       expect(svgargs.render?(0)).to be false
     end

   end

end
