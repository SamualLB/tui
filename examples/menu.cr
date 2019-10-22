require "../src/tui"

class Window1 < TUI::Window
  def paint(painter : TUI::Painter)
    painter[0, 0] = "Main Window 1"
    painter[-1, -1] = '/'
    true
  end
end

class Window2 < TUI::Window
  def paint(painter : TUI::Painter)
    painter[0, 0] = "Main Window 2"
    painter[-1, -1] = '/'
    true
  end
end

class Window3 < TUI::Window
  def paint(painter : TUI::Painter)
    painter[0, 0] = "Main Window 3"
    painter[-1, -1] = '/'
    true
  end
end

class MenuTest < TUI::Window::Main
  def initialize(parent : TUI::Window? = nil)
    super
    top_menu = TUI::Window::Menu.new(self)
    stack = TUI::Window::Stacked.new(self)
    TUI::Button.new(top_menu, "11111") { stack.index = 0 }
    TUI::Button.new(top_menu, "2222") { stack.index = 1 }
    TUI::Button.new(top_menu, "333") { stack.index = 2 }
    self.top = top_menu
    Window1.new(stack)
    Window2.new(stack)
    Window3.new(stack)
    layout << stack
    bottom_menu = TUI::Window::Menu.new(self)
    TUI::Window::MenuItem.new(bottom_menu, "bot")
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
