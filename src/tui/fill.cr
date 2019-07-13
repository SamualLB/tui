class TUI::Fill
  include TUI::Painter

  property! ch : Char

  def initialize(@ch : Char) end

  def paint(surface : TUI::Surface) : TUI::Surface
    surface.w.times do |w|
      surface.h.times do |h|
        c = TUI::Cell.new
        c.char = ch
        surface[{w, h}] = c
      end
    end
    surface
  end

  def min_size : {Int32, Int32}
    {0, 0}
  end

  def size? : {Int32, Int32}?
    nil
  end

  def max_size : {Int32, Int32}
    {Int32.max, Int32.max}
  end
end
