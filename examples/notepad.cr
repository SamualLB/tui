require "./../src/tui/*"
require "./../src/tui/backend/ncurses"

class Notepad < TUI::Window

end

app = TUI::Application.new(Notepad)

app.exec

p app.@main_window.parent
