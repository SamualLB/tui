class TUI::Layout::Stacked < TUI::Layout
  @index : Int32 | Nil = nil

  @windows = [] of Window

  # Sets selected window to full screen
  def set(event, w, h)
    @windows.each_with_index do |win, i|
      win.x = 0
      win.y = 0
      if i == @index
        win.w = w
        win.h = h
      else
        win.w = 0
        win.h = 0
      end
      win.handle(event)
    end
  end

  def <<(win : Window)
    delete(win)
    @windows << win
    @index = 0 if @windows.size == 1
  end

  def delete(win : Window)
    @windows.delete win
  end

  def top? : Window?
    return nil unless i = @index
    @windows[i]?
  end

  def top : Window
    @windows[@index.as(Int32)]
  end

  def index=(new : Int32)
    @index = new
    window.app.dispatch_resize
  end

  def each_window(&block)
    @windows.each { |win| yield win if win.is_a? Window }
  end
end
