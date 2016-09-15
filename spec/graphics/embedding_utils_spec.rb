require 'spec_helper'
require 'squib/graphics/embedding_utils'

describe Squib::EmbeddingUtils do

  context(:indices) do
    it 'returns nothing when given nothing' do
      expect(Squib::EmbeddingUtils.indices('just some text', [])).to eq({})
    end

    it 'returns emptiness for given keys that are not in the string' do
      str = 'just some text'
      keys = [':tool:']
      expect(Squib::EmbeddingUtils.indices(str, keys)).to eq({
        ':tool:' => []
      })
    end

    it 'returns correctly for one key, one time' do
      str = 'some :tool: text'
      keys = [':tool:']
      expect(Squib::EmbeddingUtils.indices(str, keys)).to eq({
        ':tool:' => [5..11]
      })
    end

    it 'handles one key, multiple times' do
      str = 'some :tool: text :tool:'
      keys = [':tool:']
      expect(Squib::EmbeddingUtils.indices(str, keys)).to eq({
        ':tool:' => [5..11, 17..23]
      })
    end

    it 'handles one key, multiple times next to each other' do
      str = 'some :tool::tool: text'
      keys = [':tool:']
      expect(Squib::EmbeddingUtils.indices(str, keys)).to eq({
        ':tool:' => [5..11, 11..17]
      })
    end

    it 'handles multiple keys, one time each' do
      str = 'some :tool: heart text'
      keys = %w(:tool: heart)
      expect(Squib::EmbeddingUtils.indices(str, keys)).to eq({
        ':tool:' => [5..11],
        'heart' => [12..17]
      })
    end

    it 'handles multiple keys, multiple times each' do
      str = ':tool:some :tool: heart text heart tool'
      keys = %w(:tool: heart)
      expect(Squib::EmbeddingUtils.indices(str, keys)).to eq({
        ':tool:' => [0..6, 11..17],
        'heart' => [18..23, 29..34]
      })
    end

    it 'handles multibyte properly' do
      str = '💡 📷 :tool: heart text'
      keys = %w(:tool: heart 💡)
      expect(Squib::EmbeddingUtils.indices(str, keys)).to eq({
        ':tool:' => [10..16],
        'heart' => [17..22],
        '💡' => [3..4]
      })
    end


  end
end
