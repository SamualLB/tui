require "../src/tui"

class Notepad < TUI::Window
  @buffer = IO::Memory.new
  @mode = Mode::Command

  def paint(painter : TUI::Painter)
    painter[0, 0] = "Mode: #{@mode}"
    painter[0, 1] = @buffer.to_s
    true
  end

  def key(event : TUI::Event::Key) : Bool
    case @mode
    when Mode::Insert
      case k = event.key
      when TUI::Key::Escape then @mode = Mode::Command
      when TUI::Key::Backspace then @buffer.pos = @buffer.pos-1
      when '\t' then @buffer << ((@buffer.pos % 2 == 0) ? "  " : ' ')
      when Char then @buffer << k
      end
    when Mode::Command
      case event.key
      when 'i' then @mode = Mode::Insert
      when 'q' then app.stop = true
      end
    end
    true
  end

  enum Mode
    Command
    Insert
  end
end

win = Notepad.new

app = TUI::Application.new(win, TUI::Backend::NCurses, fps: 2.5, title: "Notepad")

win.set_focused true

app.exec
