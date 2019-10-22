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
end

class SplitChild1 < TUI::Window
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

class SplitChild2 < TUI::Window
  def paint(painter : TUI::Painter)
    painter[1, 1] = "Child 2"
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

win = Split.new
SplitChild1.new(win)
SplitChild2.new(win)


app = TUI::Application.new(win, TUI::Backend::NCurses, fps: 2.5, title: "Vertical Split")

app.exec
