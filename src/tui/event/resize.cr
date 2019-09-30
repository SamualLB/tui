struct TUI::Event::Resize < TUI::Event
  @s : {Int32, Int32}

  def initialize(@s)
    super()
  end

  def initialize(w : Int32, h : Int32)
    @s = {w, h}
    super()
  end

  def size
    @s
  end

  def width
    @s[0]
  end

  def height
    @s[1]
  end

  def size=(new_s : {Int32, Int32})
    @s = new_s
  end
end
