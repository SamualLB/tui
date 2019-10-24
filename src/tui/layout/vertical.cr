class TUI::Layout::Vertical < TUI::Layout

  @items = [] of Widget

  # Very basic, lays out each Widget with height/no. of widget as the height
  # and full width
  def set(event, rect : Rect)
    return if @items.empty?
    height_for_each = rect.h // @items.size
    height_for_last = height_for_each + rect.h - (height_for_each * @items.size)
    @items.each_with_index do |item, i|
      item.rect = Rect.new(
        0,
        height_for_each * i,
        rect.w,
        item == @items.last ? height_for_last : height_for_each)
      item.handle(event) if item.is_a?(Widget)
    end
  end

  def <<(win : Widget)
    delete(win)
    @items << win
  end

  def delete(win : Widget)
    @items.delete win
  end

  def each_widget(&block)
    @items.each { |item| yield item if item.is_a? Widget }
  end
end
