class TUI::Layout::Modal < TUI::Layout
  @bottom : Widget?
  @top : Widget?

  def set(event, rect : Rect)
    @bottom.try do |b|
      b.rect = Rect.new(rect.x, rect.y, rect.w, rect.h)
      b.handle(event)
    end
    @top.try do |t|
      t.rect = Rect.new(rect.x, rect.y, rect.w, rect.h)
      t.handle(event)
    end
  end

  def <<(w : Widget)
    return if w == @top || w == @bottom
    @bottom = w
  end

  def bottom=(w : Widget)
    @bottom = w
  end

  def top=(w : Widget)
    @top = w
  end

  def delete(w : Widget)
    @bottom = nil if @bottom == w
    @top = nil if @top == w
  end

  def each_widget(&block)
    @bottom.try { |w| yield w }
    @top.try { |w| yield w }
  end

  # Override to exclude bottom widget
  def each_widget_mouse(&block)
    @top.try { |w| yield w }
  end
end
