require "./../src/tui/*"
require "./../src/tui/backend/termbox"

class Notepad < TUI::Window

end

app = TUI::Application.new(Notepad, TUI::Backend::Termbox)

app.exec
