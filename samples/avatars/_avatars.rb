require 'squib'
require 'squib/sample_helpers'

Squib::Deck.new(width: 1000, height: 2050, config: 'avatar_config.yml') do
  draw_graph_paper width, height

  sample "Avatar library - 'male'." do |x, y|
    avatar library: 'male', seed: 'abcde', x: x, y: y, width: 96, height: 96
    avatar library: 'male', seed: 'fghij', x: x + 125, y: y, width: 96, height: 96
  end

  sample "Avatar library - 'female'." do |x, y|
    avatar library: 'female', seed: 'abcde', x: x, y: y, width: 96, height: 96
    avatar library: 'female', seed: 'fghij', x: x + 125, y: y, width: 96, height: 96
  end

  sample "Avatar library - 'human'." do |x, y|
    avatar library: 'human', seed: 'abcde', x: x, y: y, width: 96, height: 96
    avatar library: 'human', seed: 'fghij', x: x + 125, y: y, width: 96, height: 96
  end

  sample "Avatar library - 'identicon'." do |x, y|
    avatar library: 'identicon', seed: 'abcde', x: x, y: y, width: 96, height: 96
    avatar library: 'identicon', seed: 'fghij', x: x + 125, y: y, width: 96, height: 96
  end

  sample "Avatar library - 'initials'." do |x, y|
    avatar library: 'initials', seed: 'Longer Name', x: x, y: y, width: 96, height: 96
    avatar library: 'initials', seed: 'RN', x: x + 125, y: y, width: 96, height: 96
  end

  sample "Avatar library - 'bottts'." do |x, y|
    avatar library: 'bottts', seed: 'abcde', x: x, y: y, width: 96, height: 96
    avatar library: 'bottts', seed: 'fghij', x: x + 125, y: y, width: 96, height: 96
  end

  sample "Avatar library - 'avataaars'." do |x, y|
    avatar library: 'avataaars', seed: 'abcde', x: x, y: y, width: 96, height: 96
    avatar library: 'avataaars', seed: 'fghij', x: x + 125, y: y, width: 96, height: 96
  end

  sample "Avatar library - 'jdenticon'." do |x, y|
    avatar library: 'jdenticon', seed: 'abcde', x: x, y: y, width: 96, height: 96
    avatar library: 'jdenticon', seed: 'fghij', x: x + 125, y: y, width: 96, height: 96
  end

  sample "Avatar library - 'gridy'." do |x, y|
    avatar library: 'gridy', seed: 'abcde', x: x, y: y, width: 96, height: 96
    avatar library: 'gridy', seed: 'fghij', x: x + 125, y: y, width: 96, height: 96
  end

  sample "Avatar library - 'micah'." do |x, y|
    avatar library: 'micah', seed: 'abcde', x: x, y: y, width: 96, height: 96
    avatar library: 'micah', seed: 'fghij', x: x + 125, y: y, width: 96, height: 96
  end

  save_png prefix: '_avatars_'
end
