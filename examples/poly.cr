require "../src/tui"

class PolyDrawer < TUI::Widget
  def initialize(parent : TUI::Widget? = nil)
    super
    bind 'q' { app.stop; true }
  end

  def paint(painter : TUI::Painter)
    painter.poly(
      [painter.w//8, painter.w//8*2, painter.w//8*3],
      [painter.h//8, painter.h//8*3, painter.h//8*2],
      '#', true)

    painter.poly(
      [painter.w//8*4, painter.w//8*6, painter.w//8*8, painter.w//8*5, painter.w//8*3],
      [painter.h//8*3, painter.h//8*2, painter.h//8*7, painter.h//8*8, painter.h//8*5],
      '@', true)

    painter.poly(
      [{painter.w//8*2 , painter.h//8*4},
      {painter.w//8, painter.h//8*7},
      {painter.w//8*4, painter.h//8*8}],
      '?')
    painter.centre(painter.w//2, painter.h-1, "Press q to exit example")
    true
  end
end

app = TUI::Application.new(PolyDrawer, TUI::Backend::NCurses, title: "Polygon Drawer")

app.exec
