require "../src/tui"

class ModalBG < TUI::Widget
  def initialize(parent : TUI::Widget? = nil)
    super
    @border = TUI::Border::Rounded.new
    bind 'q' { app.stop; true }
    bind 't' { ModalFG.exec(app); true }
  end

  def paint(painter : TUI::Painter)
    painter.centre(painter.w//2, painter.h//2, "Press t to show message box!")
    painter.centre(painter.w//2, painter.h-1, "Press q to exit example")
    true
  end
end

class CustomMessage < TUI::Widget
  def paint(painter : TUI::Painter)
    painter.centre(painter.w//2, painter.h//2, "Message goes here!")
    painter[0, painter.h-1] = "Press q to close message box"
    true
  end
end

class ModalFG < TUI::Widget::MessageBox
  def initialize(app : TUI::Application)
    super(app)
    msg = CustomMessage.new(self)
    but1 = TUI::Widget::Button.new(self, "Quit") do
      self.stop
      set_focused false
      TUI.logger.info "Quit pressed"
      true
    end
    but2 = TUI::Widget::Button.new(self, "Nothing") do
      TUI.logger.info "Nothing button pressed"
      true
    end
    bind 'q' do
      self.stop
      but1.set_focused false
      true
    end
  end
end



app = TUI::Application.new(ModalBG, TUI::Backend::NCurses, title: "Message Box Example")

app.exec
