require "../src/tui"

class RectDrawer < TUI::Widget
  def initialize(parent : TUI::Widget? = nil)
    super
    bind 'q' { app.stop; true }
  end

  def paint(painter : TUI::Painter)
    painter.rect(painter.w//8, painter.h//8, painter.w//8*3, painter.h//8*3, '#', true)
    painter.rect(painter.w//8*7, painter.h//8*7, painter.w//8*5, painter.h//8*5, '#')
    painter.centre(painter.w//2, painter.h-1, "Press q to exit example")
    true
  end
end

app = TUI::Application.new(RectDrawer, TUI::Backend::NCurses, title: "Rectangle Drawer")

app.exec
