require "./painter"

class TUI::HorizontalSplit
  include TUI::Painter

  property! left : TUI::Painter, right : TUI::Painter

  def paint(surface : TUI::Surface) : TUI::Surface
    surface.sub(surface.w/2, surface.h) { |s| left.paint s }
    surface.sub(surface.w/2, surface.h, surface.w-surface.w/2) { |s| right.paint s }
    surface
  end
end
