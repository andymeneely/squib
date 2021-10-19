# typed: strict
class Squib::Args::Box

  def radius; end

end

class Squib::Args::InputFile

  def placeholder; end

end

class Squib::Args::SaveBatch

  def dir; end
  def count_format; end
  def prefix; end
  def suffix; end
  def angle; end

end

class Squib::Args::ScaleBox

  def width; end
  def height; end

end

class Squib::Args::Sheet

  def width; end
  def height; end
  def crop_marks; end
  def suffix; end
  def dir; end
  def file; end
  def columns; end
  def count_format; end
  def prefix; end
  def range; end
  def margin; end
  def trim; end
  def crop_margin_bottom; end
  def crop_margin_top; end
  def crop_margin_left; end
  def crop_margin_right; end

end

class Squib::Args::Transform

  def crop_corner_radius; end

end

class Squib::Args::SvgSpecial

  def id; end
  def force_id; end

end