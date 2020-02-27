require "../src/tui"

class Widget1 < TUI::Widget
  def paint(painter : TUI::Painter)
    painter[0, 1] = "Main Widget 1"
    painter[-1, -1] = '/'
    painter.centre(painter.w//2, 0, "Press 1, 2, or 3 to change widget")
    painter.centre(painter.w//2, painter.h-1, "Press q to exit example")
    true
  end
end

class Widget2 < TUI::Widget
  def paint(painter : TUI::Painter)
    painter[0, 1] = "Main Widget 2"
    painter[-1, -1] = '/'
    painter.centre(painter.w//2, 0, "Press 1, 2, or 3 to change widget")
    painter.centre(painter.w//2, painter.h-1, "Press q to exit example")
    true
  end
end

class Widget3 < TUI::Widget
  def paint(painter : TUI::Painter)
    painter[0, 1] = "Main Widget 3"
    painter[-1, -1] = '/'
    painter.centre(painter.w//2, 0, "Press 1, 2, or 3 to change widget")
    painter.centre(painter.w//2, painter.h-1, "Press q to exit example")
    true
  end
end

class MenuTest < TUI::Widget::Main
  def initialize(parent : TUI::Widget? = nil)
    super
    top_menu = TUI::Widget::Menu.new(self)
    stack = TUI::Widget::Stacked.new(self)
    b1 = TUI::Widget::Button.new(top_menu, "11111") { stack.index = 0 }
    b1.border = TUI::Border::Squared.new
    TUI::Widget::Button.new(top_menu, "2222") { stack.index = 1 }
    b3 = TUI::Widget::Button.new(top_menu, "333") { stack.index = 2 }
    b3.border = TUI::Border::Rounded.new
    self.top = top_menu
    Widget1.new(stack)
    Widget2.new(stack)
    Widget3.new(stack)
    layout << stack
    bottom_menu = TUI::Widget::Menu.new(self)
    TUI::Widget::MenuItem.new(bottom_menu, "bot")
    self.bottom = bottom_menu 
    bind '1' { stack.index = 0; true }
    bind '2' { stack.index = 1; true }
    bind '3' { stack.index = 2; true }
  end
end

win = MenuTest.new
win.bind('q') do
  win.app.stop
  true
end



app = TUI::Application.new(win, TUI::Backend::NCurses, title: "Menu Test")

app.exec
