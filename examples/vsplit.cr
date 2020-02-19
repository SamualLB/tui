require "../src/tui"

class Split < TUI::Widget
  def initialize
    @layout = TUI::Layout::Vertical.new(self)
    super
    bind('q') do
      app.stop
      true
    end
  end
end

class SplitChild1 < TUI::Widget
  def paint(painter : TUI::Painter)
    painter[1, 1] = "Child 1"
    painter[1, 2] = "Dimensions: #{painter.w}x#{painter.h}"
    painter.hline(0, 0, painter.w, '─').hline(0, painter.h-1, painter.w, '─')
    painter.vline(0, 0, painter.h, '│').vline(painter.w-1, 0, painter.h, '│')
    painter[0, 0] = '╭'
    painter[-1, -1] = '╯'
    painter[-1, 0] = '╮'
    painter[0, -1] = '╰'
    true
  end
end

class SplitChild2 < TUI::Widget
  def paint(painter : TUI::Painter)
    painter[1, 1] = "Child 2"
    painter[1, 2] = "Dimensions: #{painter.w}x#{painter.h}"
    painter.hline(0, 0, painter.w, '─').hline(0, painter.h-1, painter.w, '─')
    painter.vline(0, 0, painter.h, '│').vline(painter.w-1, 0, painter.h, '│')
    painter[0, 0] = '╭'
    painter[-1, -1] = '╯'
    painter[-1, 0] = '╮'
    painter[0, -1] = '╰'
    painter.centre(painter.w//2, painter.h-2, "Press q to exit example")
    true
  end
end

win = Split.new
SplitChild1.new(win)
SplitChild2.new(win)


app = TUI::Application.new(win, TUI::Backend::NCurses, title: "Vertical Split")

app.exec
