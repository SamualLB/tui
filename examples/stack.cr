require "../src/tui"

class StackChild1 < TUI::Widget
  def paint(painter : TUI::Painter)
    painter[0, 0] = "Child 1"
    painter[0, 1] = "Dimensions: #{painter.w}x#{painter.h}"
    painter.centre(painter.w//2, painter.h//2, "Use 1 & 2 keys to switch stack widget")
    painter.centre(painter.w//2, painter.h-1, "Press q to exit example")
    true
  end
end

class StackChild2 < TUI::Widget
  def paint(painter : TUI::Painter)
    painter[0, 0] = "Child 2"
    painter[0, 1] = "Dimensions: #{painter.w}x#{painter.h}"
    painter.centre(painter.w//2, painter.h//2, "Use 1 & 2 keys to switch stack widget")
    painter.centre(painter.w//2, painter.h-1, "Press q to exit example")
    true
  end
end

win = TUI::Widget::Stacked.new
win.bind('q') do
  win.app.stop
  true
end
win.bind '1' { win.index = 0; true }
win.bind '2' { win.index = 1; true }

StackChild1.new(win)
child_2 = StackChild2.new(win)

app = TUI::Application.new(win, TUI::Backend::NCurses, child_2, title: "Stack Test")

app.exec
