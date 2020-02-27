class TUI::Layout::Menu < TUI::Layout
    @items = [] of TUI::Widget::MenuItem

    def set(event, rect)
      return if @items.empty?
      offset = 0
      max_height = 1
      @items.each do |item|
        i_height = item.height
        max_height = i_height if i_height && i_height > max_height
      end
      @items.each do |item|
        item.rect = Rect.new(offset, 0, item.width, max_height)
        item.handle(event)
        offset += item.w + 1
      end
    end

    def <<(item : Widget)
      raise "#{self} can only store MenuItems"
    end

    def <<(item : Widget::MenuItem)
      delete(item)
      @items << item
    end

    def delete(item : Widget)
      @items.delete(item)
    end

    def each_widget(&block)
      @items.each { |i| yield i }
    end
   
  end
