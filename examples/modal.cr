require "../src/tui"

class ModalBG < TUI::Widget
  def initialize(parent : TUI::Widget? = nil)
    super
    @border = TUI::Border::Rounded.new
    bind 'q' { app.stop; true }
    bind 't' { ModalFG.exec(app); true }
  end

  def paint(painter : TUI::Painter)
    painter.centre(painter.w//2, painter.h//2, "Press t to show modal")
    painter[painter.w//8, painter.h//8] = '~'
    painter[painter.w//8*3, painter.h//8*5] = '~'
    painter.centre(painter.w//2, painter.h-1, "Press q to quit example")
    true
  end
end

class ModalFG < TUI::Widget::Modal
  def initialize(app : TUI::Application)
    super(app)
    @border = TUI::Border::Squared.new
    bind 'q' { self.stop; true }
  end

  def paint(painter : TUI::Painter)
    painter.clear(rect)
    painter.centre(painter.w//2, painter.h//2, "Press q to exit modal!")
    true
  end
end

app = TUI::Application.new(ModalBG, TUI::Backend::NCurses, title: "Modal Example")

app.exec
