require "../src/tui"

class TextEditorTest < TUI::Widget::Main
  getter! editor : TUI::Widget::TextEditor

  def initialize(parent : TUI::Widget? = nil)
    super
    layout << (@editor = TUI::Widget::TextEditor.new(self))
    unbind 'q'
    bind(TUI::Key::Escape) { app.stop; true }
  end

  def paint(painter : TUI::Painter)
    painter.centre(painter.w//2, painter.h-1, "Press escape to exit example")
    true
  end
end

win = TextEditorTest.new

app = TUI::Application.new(win, TUI::Backend::NCurses, title: "Text Editor")
win.editor.set_focused true

app.exec
