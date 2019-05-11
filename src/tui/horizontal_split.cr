require "./painter"

class TUI::HorizontalSplit
  include TUI::Painter

  property! left : TUI::Painter, right : TUI::Painter

  def paint(surface : TUI::Surface) : TUI::Surface
    surface.sub(surface.w/2, surface.h) { |s| left.paint s }
    surface.sub(surface.w/2, surface.h, surface.w-surface.w/2) { |s| right.paint s }
    surface
  end

  def min_size
    l = left.min_size
    r = right.min_size
    {l[0]+r[0], l[1] > r[1] ? l[1] : r[1]}
  end

  def size?
    l = left.size? || left.min_size
    r = right.size? || right.min_size
    {l[0]+r[0], l[1] > r[1] ? l[1] : r[1]}
  end

  def max_size
    min_size
  end
end
