require "../src/tui"

class BorderTest < TUI::Widget
  def initialize
    @layout = TUI::Layout::Vertical.new(self)
    super
    bind('q') do
      TUI.logger.info "Exiting"
      app.stop = true
    end
  end
end

class SplitChild1 < TUI::Widget
  def paint(painter : TUI::Painter)
    TUI::Border::Rounded.new.paint(painter)
    painter[1, 0] = "Child 1"
    painter[1, 1] = "Dimensions: #{painter.w}x#{painter.h}"
    painter.pop
    true
  end
end

class SplitChild2 < TUI::Widget
  def paint(painter : TUI::Painter)
    TUI::Border::Squared.new.paint(painter)
    painter[1, 1] = "Child 2"
    painter[1, 2] = "Dimensions: #{painter.w}x#{painter.h}"
    painter.pop
    true
  end
end

win = BorderTest.new
SplitChild1.new(win)
SplitChild2.new(win)


app = TUI::Application.new(win, TUI::Backend::NCurses, fps: 2.5, title: "Vertical Split")

app.exec
