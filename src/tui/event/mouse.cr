struct TUI::Event::Mouse < TUI::Event
  getter! mouse : TUI::MouseStatus
  getter! position : {Int32, Int32}

  def initialize(@mouse, @position)
    super()
  end

  def initialize(@mouse)
    super()
  end

  def initialize(@position)
    super()
  end

  def initialize()
    super()
  end

  protected def mouse=(@mouse : TUI::MouseStatus)
  end

  protected def position=(@position : {Int32, Int32})
  end

  def x : Int32
    position[0]
  end

  def y : Int32
    position[1]
  end
end
