require "../src/tui"

class TextEditorTest < TUI::Widget::Main
  getter! editor : TUI::Widget::TextEditor

  def initialize(parent : TUI::Widget? = nil)
    super
    layout << (@editor = TUI::Widget::TextEditor.new(self))
    unbind 'q'
    bind(TUI::Key::Escape) { app.stop = true }
  end
end

win = TextEditorTest.new

app = TUI::Application.new(win, TUI::Backend::NCurses, fps: 5, title: "Text Editor")
win.editor.set_focused true

app.exec
