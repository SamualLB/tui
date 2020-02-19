require "../src/tui"

class BorderTest < TUI::Widget
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
  def initialize(par : TUI::Widget? = nil)
    super(par)
    @border = TUI::Border::Rounded.new
  end

  def paint(painter : TUI::Painter)
    painter[1, 0] = "Rounded Borders"
    painter[1, 1] = "Dimensions: #{painter.w}x#{painter.h}"
    true
  end
end

class SplitChild2 < TUI::Widget
  def initialize(par : TUI::Widget? = nil)
    super(par)
    @border = TUI::Border::Custom.new do |painter|
      painter[0, 0] = '/'
      painter[-1, -1] = '/'
      painter[0, -1] = '\\'
      painter[-1, 0] = '\\'
      painter.push(1, 1, painter.w-2, painter.h-2)
    end
  end

  def paint(painter : TUI::Painter)
    painter[1, 0] = "Custom Borders"
    painter[1, 1] = "Dimensions: #{painter.w}x#{painter.h}"
    painter.centre(painter.w//2, painter.h-1, "Press q to exit example")
    true
  end
end

win = BorderTest.new
SplitChild1.new(win)
SplitChild2.new(win)


app = TUI::Application.new(win, TUI::Backend::NCurses, title: "Vertical Split")

app.exec
