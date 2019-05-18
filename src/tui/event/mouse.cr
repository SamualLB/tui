struct TUI::Event::Mouse < TUI::Event
  @m : TUI::MouseStatus? = nil
  @p : {Int32, Int32}? = nil

  def initialize(@m, @p)
    super()
  end

  def initialize(@m)
    super()
  end

  def initialize(@p)
    super()
  end

  def initialize()
    super
  end

  def mouse
    @m.not_nil!
  end

  protected def mouse=(new_m : TUI::MouseStatus)
    @m = new_m
  end

  def position
    @p.not_nil!
  end

  protected def position=(new_p : {Int32, Int32})
    @p = new_p
  end
end
