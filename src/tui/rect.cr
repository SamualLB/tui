struct TUI::Rect
  getter x : Int32, y : Int32, w : Int32, h : Int32

  def initialize(@x, @y, @w, @h)
  end

  def initialize(@w, @h)
    @x = 0
    @y = 0
  end
end
