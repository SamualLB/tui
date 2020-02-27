struct TUI::Border::None < TUI::Border
  def paint(painter : Painter)
    painter.push(0, 0)
    nil
  end

  def width
    0
  end

  def height
    0
  end

  def width(h)
    0
  end

  def height(w)
    0
  end
end
