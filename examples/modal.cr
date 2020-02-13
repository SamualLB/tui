require "../src/tui"

class ModalBG < TUI::Widget
  def initialize(parent : TUI::Widget? = nil)
    super
    @border = TUI::Border::Rounded.new
    bind 'q' { app.stop = true; true }
    bind 't' { ModalFG.exec(app); true }
  end

  def paint(painter : TUI::Painter)
    painter[painter.w//2, painter.h//2] = "Test!"
    true
  end
end

class ModalFG < TUI::Modal
  def initialize(app : TUI::Application)
    super(app)
    @border = TUI::Border::Squared.new
    bind 'q' { @stop = true; true }
  end

  def paint(painter : TUI::Painter)
    painter[painter.w//2, painter.h//2] = "Foreground"
    true
  end
end

app = TUI::Application.new(ModalBG, TUI::Backend::NCurses, title: "Modal Example")

app.exec
