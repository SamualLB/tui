require "../src/tui"

class LineDrawer < TUI::Widget
  def initialize(parent : TUI::Widget? = nil)
    super
    bind 'q' { app.stop; true }
  end

  def paint(painter : TUI::Painter)
    painter.line(0, 0, painter.w-1, painter.h-1, '*', true)
    painter.line(painter.w-1, 0, 0, painter.h-1, '@')
    painter.line(0, painter.h//4, painter.w-1, painter.h//4, '#', true)

    painter.vline(painter.w//4, 0, painter.h//2, '+', true)
    painter.hline(0, painter.h//4*3, painter.w//2, '-')
    painter.centre(painter.w//2, painter.h-1, "Press q to exit example")
    true
  end
end

app = TUI::Application.new(LineDrawer, TUI::Backend::NCurses, title: "Line Drawer")

app.exec
