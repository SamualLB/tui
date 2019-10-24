class TUI::Layout::Horizontal < TUI::Layout

  @items = [] of Widget

  # Very basic, lays out each Widget with width/no. of widget as the width
  # and full height
  def set(event, rect)
    return if @items.empty?
    width_for_each = rect.w // @items.size
    width_for_last = width_for_each + rect.w - (width_for_each * @items.size)
    @items.each_with_index do |item, i|
      item.rect = Rect.new(
        width_for_each * i,
        0,
        item == @items.last ? width_for_last : width_for_each,
        rect.h)
      item.handle(event) if item.is_a?(Widget)
    end
  end

  def <<(win : Widget)
    delete(win)
    @items << win
  end

  def delete(win : Widget)
    @items.delete(win)
  end

  def each_widget(&block)
    @items.each { |item| yield item if item.is_a? Widget }
  end
end
