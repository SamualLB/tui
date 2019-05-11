class TUI::Overlay
  include TUI::Painter

  property! background : TUI::Painter
  property! foreground : TUI::Painter
  property! anchor : TUI::Anchor = TUI::Anchor::Center

  def paint(surface : TUI::Surface) : TUI::Surface
    surface.sub()
  end

  private def calc_coords : {Int32, Int32}
    case anchor

    end
  end
end
