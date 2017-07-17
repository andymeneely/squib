module Squib

  # Some helper methods specifically for samples
  # @api private
  #:nodoc:
  class Deck

    # Draw graph paper for samples
    def draw_graph_paper(width, height)
      background color: 'white'
      grid width: 50,  height: 50,  stroke_color: '#659ae9', stroke_width: 1.5
      grid width: 200, height: 200, stroke_color: '#659ae9', stroke_width: 3, x: 50, y: 50
      (50..height).step(200) do |y|
        text str: "y=#{y}", x: 3, y: y - 18, font: 'Open Sans, Sans 10'
      end
    end

    # Define a set of samples on some graph paper
    def sample(str)
      @sample_x ||= 100
      @sample_y ||= 100
      rect x: 460, y: @sample_y - 40, width: 600,
           height: 180, fill_color: '#FFD655', stroke_color: 'black', radius: 15
      text str: str, x: 460, y: @sample_y - 40,
           width: 540, height: 180,
           valign: 'middle', align: 'center',
           font: 'Times New Roman,Serif 8'
      yield @sample_x, @sample_y
      @sample_y += 200
    end

  end

end
