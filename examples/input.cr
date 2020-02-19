require "../src/tui"

class Input < TUI::Widget
  @prev_input : TUI::Event? = nil

  def initialize(parent : TUI::Widget? = nil)
    super
    bind('q') do
      app.stop
      true
    end
    unbind TUI::MouseStatus::PrimaryClick
  end

  def key(e : TUI::Event::Key)
    @prev_input = e
    if (k = e.@key).is_a?(Char)
    end
    self.dirty = true
    true
  end

  def mouse(e : TUI::Event::Mouse)
    @prev_input = e
    self.dirty = true
    true
  end

  def paint(painter : TUI::Painter)
    painter.centre(painter.w//2, 0, "Use the mouse or press a key")
    painter.centre(painter.w//2, painter.h//2, case i = @prev_input
    when TUI::Event::Mouse then "Mouse event: #{i.mouse} #{i.position}"
    when TUI::Event::Key then "Key event: #{i.key}"
    else "~~~~~~~"
    end)
    painter.centre(painter.w//2, painter.h-1, "Press q to exit example")
    true
  end
end

win = Input.new

app = TUI::Application.new(win, TUI::Backend::NCurses, win, title: "Input Test")

app.exec
