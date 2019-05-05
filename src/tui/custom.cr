require "./painter"

class TUI::Custom
  include TUI::Painter

  property! proc : Proc(TUI::Surface, TUI::Surface)

  def paint(surface : TUI::Surface) : TUI::Surface
    proc.call(surface)
    surface
  end
end
