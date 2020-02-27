struct TUI::Border::Custom < TUI::Border
  @proc : Proc(Painter, Nil)

  def initialize(@c_w = 0, @c_h = 0, &block : Painter -> Nil)
    @proc = block
  end

  def paint(painter : Painter)
    @proc.call(painter)
  end

  def width
    @c_w
  end

  def height
    @c_h
  end

  def width(w)
    @c_w
  end

  def height(w)
    @c_h
  end
end
