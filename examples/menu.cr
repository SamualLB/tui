require "../src/tui"

class Widget1 < TUI::Widget
  def paint(painter : TUI::Painter)
    painter[0, 0] = "Main Widget 1"
    painter[-1, -1] = '/'
    true
  end
end

class Widget2 < TUI::Widget
  def paint(painter : TUI::Painter)
    painter[0, 0] = "Main Widget 2"
    painter[-1, -1] = '/'
    true
  end
end

class Widget3 < TUI::Widget
  def paint(painter : TUI::Painter)
    painter[0, 0] = "Main Widget 3"
    painter[-1, -1] = '/'
    true
  end
end

class MenuTest < TUI::Widget::Main
  def initialize(parent : TUI::Widget? = nil)
    super
    top_menu = TUI::Widget::Menu.new(self)
    stack = TUI::Widget::Stacked.new(self)
    TUI::Button.new(top_menu, "11111") { stack.index = 0 }
    TUI::Button.new(top_menu, "2222") { stack.index = 1 }
    TUI::Button.new(top_menu, "333") { stack.index = 2 }
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
  TUI.logger.info "Exiting"
  win.app.stop = true
end



app = TUI::Application.new(win, TUI::Backend::NCurses, fps: 5, title: "Menu Test")

app.exec
