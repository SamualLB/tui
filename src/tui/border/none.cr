struct TUI::Border::None < TUI::Border
  def paint(painter : Painter)
    painter.push(0, 0)
    nil
  end

  def width : Int32
    0
  end

  def height : Int32
    0
  end

  def width(h) : Int32
    0
  end

  def height(w) : Int32
    0
  end
end
