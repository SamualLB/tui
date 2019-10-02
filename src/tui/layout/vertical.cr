class TUI::Layout::Vertical < TUI::Layout

  @items = [] of Window

  # Very basic, lays out each Window with height/no. of window as the height
  # and full width
  def set(event, w, h)
    return if @items.empty?
    height_for_each = h // @items.size
    height_for_last = height_for_each + h - (height_for_each * @items.size)
    @items.each_with_index do |item, i|
      item.x = 0
      item.y = 0 + (height_for_each * i)
      item.w = w
      item.h = item == @items.last ? height_for_last : height_for_each
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
