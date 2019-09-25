require "../src/tui"

class Notepad < TUI::Window
  def paint(painter : TUI::Painter)
    painter[0, 0] = 'N'
    painter[1, 0] = 'o'
    painter[2, 0] = 't'
    painter[3, 0] = 'e'
    painter[4, 0] = 'p'
    painter[5, 0] = 'a'
    painter[6, 0] = 'd'
  end
end

app = TUI::Application.new(Notepad, TUI::Backend::Termbox, fps: 2.5)

app.exec
