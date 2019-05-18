struct TUI::Event::Resize < TUI::Event
  @s : {Int32, Int32}? = nil

  def initialize(@s)
    super()
  end

  def size
    @s.not_nil!
  end

  def size=(new_s : {Int32, Int32})
    @s = new_s
  end
end
