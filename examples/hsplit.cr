require "../src/tui"

class Split < TUI::Widget
  def initialize
    @layout = TUI::Layout::Horizontal.new(self)
    super
    bind('q') do
      app.stop
      true
    end
  end

  def paint(painter : TUI::Painter)
    true
  end
end

class SplitChild1 < TUI::Widget
  def paint(painter : TUI::Painter)
    painter[0, 0] = "Child 1"
    painter[0, 1] = "Dimensions: #{painter.w}x#{painter.h}"
    painter[-1, -1] = '┘'
    painter[-1, 0] = '┐'
    painter[0, -1] = '└'
    if (h = self.hover)
      painter[0, 0] = "Child 1 hovered"
      painter.centre(painter.w//2, 2, "Hovering!")
      painter[h[0], h[1]] = "#"
    end
    painter.centre(painter.w//2, painter.h-1, "Press q to exit example")
    true
  end
end

class SplitChild2 < TUI::Widget
  def paint(painter : TUI::Painter)
    painter[0, 0] = "Child 2"
    painter[0, 1] = "Dimensions: #{painter.w}x#{painter.h}"
    painter[-1, -1] = '┘'
    painter[-1, 0] = '┐'
    painter[0, -1] = '└'
    if (h = self.hover)
      painter[0, 0] = "Child 2 hovered"
      painter.centre(painter.w//2, 2, "Hovering!")
      painter[h[0], h[1]] = "#"
    end

    true
  end
end

win = Split.new
SplitChild1.new(win)
SplitChild2.new(win)


app = TUI::Application.new(win, TUI::Backend::NCurses, title: "Horizontal Split")

app.exec
