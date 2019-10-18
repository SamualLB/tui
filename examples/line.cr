require "../src/tui"

class LineDrawer < TUI::Window
  def initialize(parent : TUI::Window? = nil)
    super
    bind 'q' { app.stop = true; true }
  end

  def paint(painter : TUI::Painter)
    painter.line(0, 0, painter.w-1, painter.h-1, '*')
    painter.line(painter.w-1, 0, 0, painter.h-1, '@')
    painter.line(0, painter.h//4, painter.w-1, painter.h//4, '#')

    painter.vline(painter.w//4, 0, painter.h//2, '+')
    painter.hline(0, painter.h//4*3, painter.w//2, '-')
    true
  end
end

app = TUI::Application.new(LineDrawer, TUI::Backend::NCurses, fps: 2.5, title: "Line Drawer")

app.exec
