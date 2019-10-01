class TUI::Layout::Horizontal < TUI::Layout

  # Very basic, lays out each Window with width/no. of window as the width
  # and full height
  def set(event, w, h)
    width_for_each = w // @items.size
    width_for_last = w - (width_for_each * @items.size)
    @items.each_with_index do |item, i|
      item.x = 0 + (width_for_each * i)
      item.y = 0
      item.w = item == @items.last ? width_for_last : width_for_each
      item.h = h
    end
  end
end
