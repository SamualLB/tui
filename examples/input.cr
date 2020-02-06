require "../src/tui"

class Input < TUI::Widget
  @prev_input : TUI::Event? = nil

  def initialize(parent : TUI::Widget? = nil)
    super
    bind('q') do
      TUI.logger.info "Exiting"
      app.stop = true
    end
    unbind TUI::MouseStatus::PrimaryClick
  end

  def key(e : TUI::Event::Key)
    @prev_input = e
    if (k = e.@key).is_a?(Char)
      TUI.logger.info "Key: #{k} (#{k.ord.to_s(16)})"
    end
    true
  end

  def mouse(e : TUI::Event::Mouse)
    TUI.logger.info "mouse event #{self}"
    @prev_input = e
    true
  end

  def paint(painter : TUI::Painter)
    TUI.logger.info "Drawing prev #{@prev_input}"
    painter[5, painter.h//2] = case i = @prev_input
    when TUI::Event::Mouse then "Mouse event: #{i.mouse} #{i.position}"
    when TUI::Event::Key then "Key event: #{i.key}"
    else "~~~~~~~"
    end
    true
  end
end

win = Input.new

app = TUI::Application.new(win, TUI::Backend::Termbox, win, fps: 1, title: "Input Test")

app.exec
