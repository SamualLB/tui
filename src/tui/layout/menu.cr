class TUI::Layout::Menu < TUI::Layout
    @items = [] of TUI::Window::MenuItem

    def set(event, rect)
      return if @items.empty?
      offset = 0
      @items.each do |item|
        item.rect = Rect.new(offset, 0, item.label_width, 1)
        item.handle(event)
        offset += item.w + 1
      end
    end

    def <<(item : Window)
      raise "#{self} can only store MenuItems"
    end

    def <<(item : Window::MenuItem)
      delete(item)
      @items << item
    end

    def delete(item : Window)
      @items.delete(item)
    end

    def each_window(&block)
      @items.each { |i| yield i }
    end
   
  end
