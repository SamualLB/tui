struct TUI::Rect
  getter x : Int32, y : Int32, w : Int32, h : Int32

  def initialize(@x, @y, @w, @h)
  end

  def initialize(@w, @h)
    @x = 0
    @y = 0
  end

  def relative(i, j = 0) : Rect
    if i < 0 || j < 0
      raise ArgumentError.new("Negative argument given #{i}, #{j}")
    end
    Rect.new(x+i, j+y, w-i, h-y)
  end

  def relative(i, j, e, r) : Rect
    if i < 0 || j < 0 || e < 0 || r < 0
      raise ArgumentError.new("Negative argument given #{i}, #{j}, #{e}, #{r}")
    end
    Rect.new(
      i+x,
      j+y,
      Math.max(0, Math.min(e, w-i)),
      Math.max(0, Math.min(r, y-j)))
  end
end
