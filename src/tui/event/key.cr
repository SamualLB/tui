# TODO: Handle modifiers
struct TUI::Event::Key < TUI::Event
  getter! key : TUI::Key | Char
  getter! alt : Bool
  getter! ctrl : Bool
  getter! shift : Bool

  protected setter alt, ctrl, shift

  def initialize(@key)
    super()
    @alt = false
    @ctrl = false
    @shift = false
  end

  def initialize(@key, @alt, @ctrl, @shift)
    super()
  end

  def initialize()
    super()
    @alt = false
    @ctrl = false
    @shift = false
  end

  protected def key=(@key : TUI::Key | Char)
  end
end
