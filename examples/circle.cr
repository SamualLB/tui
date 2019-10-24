require "../src/tui"

class CircleDrawer < TUI::Widget
  def initialize(parent : TUI::Widget? = nil)
    super
    bind 'q' { app.stop = true; true }
  end

  def paint(painter : TUI::Painter)
    painter.circle(painter.w//2, painter.h//2, painter.w//12, '*', true)
    painter.circle(painter.w//4, painter.h//4, painter.w//22, '-', true)
    painter.circle(painter.w//4*3, painter.h//4*3, painter.w//22, '+', true)
    true
  end
end

app = TUI::Application.new(CircleDrawer, TUI::Backend::NCurses, fps: 2.5, title: "Circle Drawer")

app.exec
