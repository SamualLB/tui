struct TUI::Border::None < TUI::Border
  def paint(painter : Painter)
    painter.push(0, 0)
    nil
  end
end
