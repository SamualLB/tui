require "../src/tui"

class StackChild1 < TUI::Window
  def paint(painter : TUI::Painter)
    painter[0, 0] = "Child 1"
    painter[0, 1] = "Dimensions: #{painter.w}x#{painter.h}"
    true
  end
end

class StackChild2 < TUI::Window
  def initialize(parent : TUI::Window)
    super
    bind('a') do |e|
      TUI.logger.info "#{self} caught 'a' binding"
      true
    end
    bind(TUI::Key::Down) { |e| TUI.logger.info "Down Key Pressed in Stack Child 2"; true }
  end

  def paint(painter : TUI::Painter)
    painter[0, 0] = "Child 2"
    painter[0, 1] = "Dimensions: #{painter.w}x#{painter.h}"
    true
  end
end

win = TUI::Window::Stacked.new
win.bind('q') do
  TUI.logger.info "Exiting"
  win.app.stop = true
end
win.bind '1' { win.index = 0; true }
win.bind '2' { win.index = 1; true }

StackChild1.new(win)
child_2 = StackChild2.new(win)

app = TUI::Application.new(win, TUI::Backend::NCurses, child_2, fps: 2.5, title: "Stack Test")

app.callback(2.5.seconds) do
  app.@window.as(TUI::Window::Stacked).layout.index = 1
end

app.exec
