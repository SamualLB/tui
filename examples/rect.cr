require "../src/tui"

class RectDrawer < TUI::Window
  def initialize(parent : TUI::Window? = nil)
    super
    bind 'q' { app.stop = true; true }
  end

  def paint(painter : TUI::Painter)
    painter.rect(painter.w//8, painter.h//8, painter.w//8*3, painter.h//8*3, '#', true)
    painter.rect(painter.w//8*7, painter.h//8*7, painter.w//8*5, painter.h//8*5, '#', true)
    true
  end
end

app = TUI::Application.new(RectDrawer, TUI::Backend::NCurses, fps: 2.5, title: "Rectangle Drawer")

app.exec
