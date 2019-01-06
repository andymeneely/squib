require 'fileutils'
require 'pathname'
require 'highline'
require 'bigdecimal'
require 'yaml'
require_relative 'data/template_option'

module Squib
  # Squib's command-line option
  module Commands
    # Generate a template definition file that can be used for
    # +save_templated_sheet+
    #
    # @api public
    class MakeSprue
      # :nodoc:
      # @api private
      def process(args, input = $stdin, output = $stdout)
        # Get definitions from the user
        @option = prompt(input, output)

        @printable_edge_right = (
          @option.sheet_width - @option.sheet_margin.right)
        @printable_edge_bottom = (
          @option.sheet_height - @option.sheet_margin.bottom)
        @card_iter_x = @option.card_width + @option.card_gap.horizontal
        @card_iter_y = @option.card_height + @option.card_gap.vertical

        # Recalculate the sheet margin if the sheet alignment is in the center
        if @option.sheet_align == :center
          @option.sheet_margin = recalculate_center_align_sheet
        end

        # We would now have to output the file
        YAML.dump generate_template, File.new(@option.output_file, 'w')
      end

      private

      # Accept user input that defines the template.
      def prompt(input, output)
        option = TemplateOption.new
        cli = HighLine.new(input, output)

        option.unit = cli.choose do |menu|
          menu.prompt = 'What measure unit should we use? '
          menu.choice(:in)
          menu.choice(:cm)
          menu.choice(:mm)
        end

        cli.choose do |menu|
          menu.prompt = 'What paper size you are using? '
          menu.choice('A4, portrait') do
            option.sheet_width = convert_measurement_value(
              210, :mm, option.unit
            )
            option.sheet_height = convert_measurement_value(
              297, :mm, option.unit
            )
          end
          menu.choice('A4, landscape') do
            option.sheet_width = convert_measurement_value(
              297, :mm, option.unit
            )
            option.sheet_height = convert_measurement_value(
              210, :mm, option.unit
            )
          end
          menu.choice('US letter, portrait') do
            option.sheet_width = convert_measurement_value(
              8.5, :in, option.unit
            )
            option.sheet_height = convert_measurement_value(
              11, :in, option.unit
            )
          end
          menu.choice('US letter, landscape') do
            option.sheet_width = convert_measurement_value(
              11, :in, option.unit
            )
            option.sheet_height = convert_measurement_value(
              8.5, :in, option.unit
            )
          end
          menu.choice('Custom size') do
            option.sheet_width = cli.ask(
              "Custom paper width? (#{option.unit}) ", Float
            )
            option.sheet_height = cli.ask(
              "Custom paper height? (#{option.unit}) ", Float
            )
          end
        end

        option.sheet_margin = cli.ask(
          "Sheet margins? (#{option.unit}) "
        ) do |q|
          q.validate = /^((\d+\.\d+|\d+) ){0,3}(\d+\.\d+|\d+)/
        end
        option.sheet_align = cli.choose do |menu|
          menu.prompt = 'How to align cards on sheet? [left] '
          menu.choice(:left)
          menu.choice(:right)
          menu.choice(:center)
          menu.default = :left
        end

        option.card_width = cli.ask(
          "Card width? (#{option.unit}) ", Float
        ) { |q| q.above = 0 }
        option.card_height = cli.ask(
          "Card height? (#{option.unit}) ", Float
        ) { |q| q.above = 0 }
        option.card_gap = cli.ask(
          "Gap between cards? (#{option.unit}) "
        ) { |q| q.validate = /^((\d+\.\d+|\d+))(\s+(\d+\.\d+|\d+))?/ }

        option.card_ordering = cli.choose do |menu|
          menu.prompt = 'How to layout your cards? [rows]'
          menu.choice(:rows, text: 'In rows')
          menu.choice(:columns, text: 'In columns')
          menu.default = :rows
        end

        option.crop_lines = cli.choose do |menu|
          menu.prompt = 'Generate crop lines? [true]'
          menu.choice(:true)
          menu.choice(:false)
          menu.default = :true
        end

        option.output_file = cli.ask('Output to? ') do |q|
          q.validate = lambda do |path_str|
            path = Pathname.new path_str
            if path.exist?
              path.writable? && !path.directory?
            else
              path.dirname.writable?
            end
          end

          q.responses[:not_valid] = (
            'The filename specified is not a writable file or is a directory.'
          )
          q.default = 'template.yml'
        end

        option
      end

      def convert_measurement_value(val, from_unit, to_unit)
        return val if from_unit == to_unit

        if from_unit == :in
          val_mm = val * 25.4
        elsif from_unit == :cm
          val_mm = val * 10.0
        else
          val_mm = val
        end

        if to_unit == :in
          val_mm / 25.4
        elsif to_unit == :cm
          val_mm / 10.0
        else
          val_mm
        end
      end

      def generate_template
        x = @option.sheet_margin.left
        y = @option.sheet_margin.top
        cards = []
        horizontal_crop_lines = Set.new
        vertical_crop_lines = Set.new

        while (
            x + @card_iter_x < @printable_edge_right &&
            y + @card_iter_y < @printable_edge_bottom)
          xpos = x + @option.card_gap.horizontal
          ypos = y + @option.card_gap.vertical
          cards.push(
            'x' => "#{xpos}#{@option.unit}",
            'y' => "#{ypos}#{@option.unit}"
          )

          # Append the crop lines
          vertical_crop_lines.add xpos
          vertical_crop_lines.add xpos + @option.card_width
          horizontal_crop_lines.add ypos
          horizontal_crop_lines.add ypos + @option.card_height

          # Calculate the next iterator
          if @option.card_ordering == :rows
            x, y = next_card_pos_row(x, y)
          elsif @option.card_ordering == :columns
            x, y = next_card_pos_col(x, y)
          else
            raise RunTimeException, 'Invalid card ordering value received'
          end
        end

        output = {
          'sheet_width' => "#{@option.sheet_width}#{@option.unit}",
          'sheet_height' => "#{@option.sheet_height}#{@option.unit}",
          'card_width' => "#{@option.card_width}#{@option.unit}",
          'card_height' => "#{@option.card_height}#{@option.unit}",
          'cards' => cards
        }

        if @option.crop_lines == :true
          lines = []
          vertical_crop_lines.each do |val|
            lines.push(
              'type' => :vertical, 'position' => "#{val}#{@option.unit}"
            )
          end
          horizontal_crop_lines.each do |val|
            lines.push(
              'type' => :horizontal, 'position' => "#{val}#{@option.unit}"
            )
          end
          output['crop_line'] = { 'lines' => lines }
        end

        # Return the output data
        output
      end

      def recalculate_center_align_sheet
        # We will still respect the user specified margins
        printable_width = (
          @option.sheet_width - @option.sheet_margin.left -
          @option.sheet_margin.right)
        num_of_cols, remainder = printable_width.divmod(@card_iter_x)
        if (
            @option.card_gap.horizontal > 0 &&
            remainder < @option.card_gap.horizontal)
          num_of_cols -= 1
        end

        new_hor_margin = (
          (@option.sheet_width - num_of_cols * @card_iter_x -
           @option.card_gap.horizontal) / 2)
        Margin.new [
          @option.sheet_margin.top,
          new_hor_margin,
          @option.sheet_margin.bottom
        ]
      end

      def next_card_pos_row(x, y)
        x += @card_iter_x

        if (x + @card_iter_x) > @printable_edge_right
          x = @option.sheet_margin.left
          y += @card_iter_y
        end

        [x, y]
      end

      def next_card_pos_col(x, y)
        y += @card_iter_y

        if (y + @card_iter_y) > @printable_edge_bottom
          x += @card_iter_x
          y = @option.sheet_margin.top
        end

        [x, y]
      end
    end
  end
end
