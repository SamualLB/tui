class TUI::Layout::Vertical < TUI::Layout

  @items = [] of Window

  # Very basic, lays out each Window with height/no. of window as the height
  # and full width
  def set(event, w, h)
    return if @items.empty?
    height_for_each = h // @items.size
    height_for_last = h - (height_for_each * @items.size)
    @items.each_with_index do |item, i|
      item.x = 0
      item.y = 0 + (height_for_each * i)
      item.w = w
      item.h = item == @items.last ? height_for_last : height_for_each
    end
  end
end
