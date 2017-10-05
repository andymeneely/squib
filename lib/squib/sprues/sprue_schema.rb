module Squib
  module Sprues
    UNIT_REGEX = /^(\d*[.])?\d+(in|cm|mm)$/
    ROTATE_REGEX = /^(\d*[.])?\d+(deg|rad)?$/
    SCHEMA = {
      'sheet_width' => UNIT_REGEX,
      'sheet_height' => UNIT_REGEX,
      'card_width' => UNIT_REGEX,
      'card_height' => UNIT_REGEX,
      'position_reference' => ClassyHash::G.enum(:topleft, :center),
      'rotate' => [
        :optional, Numeric,
        ClassyHash::G.enum(:clockwise, :counterclockwise, :turnaround),
        ROTATE_REGEX
      ],
      'crop_line' => {
        'style' => [
          ClassyHash::G.enum(:solid, :dotted, :dashed),
          Sprues::CropLineDash::VALIDATION_REGEX
        ],
        'width' => UNIT_REGEX,
        'color' => [String, Symbol],
        'overlay' => ClassyHash::G.enum(
          :on_margin, :overlay_on_cards, :beneath_cards
        ),
        'lines' => [[{
          'type' => ClassyHash::G.enum(:horizontal, :vertical),
          'position' => UNIT_REGEX,
          'style' => [
            :optional, ClassyHash::G.enum(:solid, :dotted, :dashed)
          ],
          'width' => [:optional, UNIT_REGEX],
          'color' => [:optional, String, Symbol],
          'overlay_on_cards' => [:optional, TrueClass]
        }]]
      },
      'cards' => [[{
        'x' => UNIT_REGEX,
        'y' => UNIT_REGEX,
        'rotate' => [
          :optional, Numeric,
          ClassyHash::G.enum(:clockwise, :counterclockwise, :turnaround),
          ROTATE_REGEX
        ]
      }]]
    }.freeze
  end
end
