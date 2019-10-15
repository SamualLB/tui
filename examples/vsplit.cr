require "../src/tui"

class Split < TUI::Window
  def initialize
    @layout = TUI::Layout::Vertical.new(self)
    super
    bind('q') do
      TUI.logger.info "Exiting"
      app.stop = true
    end
  end

  def paint(painter : TUI::Painter)
    true
  end
end

class SplitChild1 < TUI::Window
  def paint(painter : TUI::Painter)
    painter[0, 0] = "Child 1"
    painter[0, 1] = "Dimensions: #{painter.w}x#{painter.h}"
    painter[-1, -1] = '┘'
    painter[-1, 0] = '┐'
    painter[0, -1] = '└'
    true
  end
end

class SplitChild2 < TUI::Window
  def initialize(parent : TUI::Window)
    super(parent)
    bind(TUI::MouseStatus::ScrollUp) do |event|
      TUI.logger.info "Scroll up event binded and caught"
      true
    end
  end

  def paint(painter : TUI::Painter)
    painter[0, 0] = "Child 2"
    painter[0, 1] = "Dimensions: #{painter.w}x#{painter.h}"
    painter[-1, -1] = '┘'
    painter[-1, 0] = '┐'
    painter[0, -1] = '└'
    true
  end
end

win = Split.new
SplitChild1.new(win)
SplitChild2.new(win)


app = TUI::Application.new(win, TUI::Backend::NCurses, fps: 2.5, title: "Vertical Split")

app.exec
