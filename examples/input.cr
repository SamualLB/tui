require "../src/tui"

class Input < TUI::Window
  @prev_input : TUI::Event? = nil

  def key(e : TUI::Event::Key)
    @prev_input = e
    true
  end

  def mouse(e : TUI::Event::Mouse)
    TUI.logger.info "mouse event #{self}"
    @prev_input = e
    true
  end

  def paint(painter : TUI::Painter)
    painter[5, painter.h//2] = case i = @prev_input
    when TUI::Event::Mouse then "Mouse event: #{i.mouse}"
    when TUI::Event::Key then "Key event: #{i.key}"
    else "~~~~~~~"
    end
    true
  end
end

win = Input.new

app = TUI::Application.new(win, TUI::Backend::NCurses, win, fps: 5, title: "Input Test")

app.exec
