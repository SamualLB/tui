# TODO: Handle modifiers
struct TUI::Event::Key < TUI::Event
  getter! key : TUI::Key | Char

  def initialize(@key)
    super()
  end

  def initialize()
    super()
  end

  protected def key=(@key : TUI::Key | Char)
  end
end
