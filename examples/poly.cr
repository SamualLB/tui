require "../src/tui"

class PolyDrawer < TUI::Window
  def initialize(parent : TUI::Window? = nil)
    super
    bind 'q' { app.stop = true; true }
  end

  def paint(painter : TUI::Painter)
    painter.poly(
      [painter.w//8, painter.w//8*2, painter.w//8*3],
      [painter.h//8, painter.h//8*3, painter.h//8*2],
      '#')

    painter.poly(
      [painter.w//8*4, painter.w//8*6, painter.w//8*8, painter.w//8*5, painter.w//8*3],
      [painter.h//8*3, painter.h//8*2, painter.h//8*7, painter.h//8*8, painter.h//8*5],
      '@')

    painter.poly(
      [{painter.w//8*2 , painter.h//8*4},
      {painter.w//8, painter.h//8*7},
      {painter.w//8*4, painter.h//8*8}],
      '?')
    true
  end
end

app = TUI::Application.new(PolyDrawer, TUI::Backend::NCurses, fps: 2.5, title: "Polygon Drawer")

app.exec
