class TUI::Fixed
  include TUI::Painter

  property! size : {Int32, Int32}
  property! child : TUI::Painter

  def paint(surface : TUI::Surface) : TUI::Surface
    surface.sub(size[0], size[1], (surface.w-size[0])/2, (surface.h-size[1])/2) { |s| child.paint s }
    surface
  end

  def min_size
    size
  end

  def max_size
    size
  end
end
