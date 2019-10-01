require "../src/tui"

class Stack < TUI::Window
  def initialize()
    @layout = TUI::Layout::Stacked.new(self)
    super
  end

  def paint(painter : TUI::Painter)
    true
  end

  def handle(event : TUI::Event::Draw) : Bool
    return false unless paint(event.painter)
    top_window = layout.as(TUI::Layout::Stacked).top
    event.painter.push(top_window.x, top_window.y, top_window.w, top_window.h)
    return false unless top_window.paint(event.painter)
    event.painter.pop
    true
  end
end

class StackChild1 < TUI::Window
  def paint(painter : TUI::Painter)
    painter[0, 0] = "Child 1"
    painter[0, 1] = "Dimensions: #{painter.w}x#{painter.h}"
    true
  end
end

class StackChild2 < TUI::Window
  def paint(painter : TUI::Painter)
    painter[0, 0] = "Child 2"
    painter[0, 1] = "Dimensions: #{painter.w}x#{painter.h}"
    true
  end
end

win = Stack.new
win.@layout.as(TUI::Layout::Stacked) << StackChild1.new(win)
win.@layout.as(TUI::Layout::Stacked) << StackChild2.new(win)

app = TUI::Application.new(win, TUI::Backend::Termbox, fps: 2.5, title: "Stack Test")

app.exec