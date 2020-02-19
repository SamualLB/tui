class TUI::Layout::MessageBox < TUI::Layout
    @buttons = [] of TUI::Widget::Button
    @message : Widget?

    # Right-aligned buttons at bottom
    #
    # Message gets remaining space
    def set(event, rect)
      offset = 0
      @buttons.each do |but|
        but.rect = Rect.new(rect.x+rect.w-but.width-offset, rect.y+rect.h-1, but.width, 1)
        but.handle(event)
        offset += but.w + 1
      end
      @message.try do |m|
        m.rect = Rect.new(rect.x, rect.y, rect.w, rect.h-1)
        m.handle(event)
      end
    end

    def message=(w : Widget)
      @message = w
    end

    def <<(but : Widget)
      @message = but
    end

    def <<(but : Widget::Button)
      delete(but)
      @buttons << but 
    end

    def delete(w : Widget)
      @buttons.delete(w)
      @message = nil if w == @message
    end

    def each_widget(&block)
      @message.try { |w| yield w }
      @buttons.each { |i| yield i }
    end
   
  end
