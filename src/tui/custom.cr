require "./painter"

class TUI::Custom
  include TUI::Painter

  property! proc : Proc(TUI::Surface, TUI::Surface)

  def paint(surface : TUI::Surface) : TUI::Surface
    proc.call(surface)
    surface
  end

  def min_size
    {0, 0}
  end

  def size?
    nil
  end

  def max_size
    {Int32.max, Int32.max}
  end
end
