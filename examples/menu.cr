require "../src/tui"

class CentreTest < TUI::Window
  def paint(painter : TUI::Painter)
    painter[0, 0] = '/'
    painter[-1, -1] = '/'
    true
  end
end

class MenuTest < TUI::Window::Main
  def initialize(parent : TUI::Window? = nil)
    super
    top_menu = TUI::Window::Menu.new(self)
    TUI::Window::MenuItem.new(top_menu, "11111")
    TUI::Window::MenuItem.new(top_menu, "2222")
    TUI::Window::MenuItem.new(top_menu, "333")
    self.top = top_menu
    layout << CentreTest.new(self)
    bottom_menu = TUI::Window::Menu.new(self)
    TUI::Window::MenuItem.new(bottom_menu, "bot")
    self.bottom = bottom_menu 
  end
end

win = MenuTest.new
win.bind('q') do
  TUI.logger.info "Exiting"
  win.app.stop = true
end



app = TUI::Application.new(win, TUI::Backend::NCurses, fps: 5, title: "Menu Test")

app.exec
