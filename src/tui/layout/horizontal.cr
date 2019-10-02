class TUI::Layout::Horizontal < TUI::Layout

  @items = [] of Window

  # Very basic, lays out each Window with width/no. of window as the width
  # and full height
  def set(event, w, h)
    return if @items.empty?
    width_for_each = w // @items.size
    width_for_last = w - (width_for_each * @items.size)
    @items.each_with_index do |item, i|
      item.x = 0 + (width_for_each * i)
      item.y = 0
      item.w = item == @items.last && !@items.first ? width_for_last : width_for_each
      item.h = h
      item.handle(event) if item.is_a?(Window)
    end
  end

  def <<(win : Window)
    delete(win)
    @items << win
  end

  def delete(win : Window)
    @items.delete(win)
  end

  def each_window(&block)
    @items.each { |item| yield item if item.is_a? Window }
  end
end
