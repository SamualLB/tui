require "../src/tui"

class Notepad < TUI::Widget
  @buffer = IO::Memory.new
  @mode = Mode::Command

  def paint(painter : TUI::Painter)
    painter[0, 0] = "Notepad!"
    painter[0, 1] = "#{@mode} mode:"
    case @mode
    when Mode::Insert then painter[15, 1] = "Press escape to exit insert mode"
    when Mode::Command
      painter[10, 0] = "Press q to exit"
      painter[15, 1] = "Press i to enter insert mode"
    end
    painter[0, 2] = @buffer.to_s
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
      when 'q' then app.stop
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

app = TUI::Application.new(win, TUI::Backend::NCurses, title: "Notepad")

win.set_focused true

app.exec
