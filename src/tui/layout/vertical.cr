class TUI::Layout::Vertical < TUI::Layout

  @items = [] of Window

  # Very basic, lays out each Window with height/no. of window as the height
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
      item.handle(event) if item.is_a?(Window)
    end
  end

  def <<(win : Window)
    delete(win)
    @items << win
  end

  def delete(win : Window)
    @items.delete win
  end

  def each_window(&block)
    @items.each { |item| yield item if item.is_a? Window }
  end
end
