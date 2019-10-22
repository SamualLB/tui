class TUI::Layout::Stacked < TUI::Layout
  @index : Int32 | Nil = nil

  @windows = [] of Window

  # Sets selected window to full screen
  def set(event, rect)
    @windows.each_with_index do |win, i|
      if i == @index
        win.rect = Rect.new(rect.w, rect.h)
      else
        win.rect = Rect.new(0, 0)
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

  def index : Int32
    @index.not_nil!
  end

  def index=(i : Int32)
    unless i < @windows.size && i >= 0
      raise "invalid stacked layout index #{i}/#{@windows.size-1}"
    end
    @index = i
    window.app.dispatch_resize
  end

  def each_window(&block)
    @windows.each { |win| yield win if win.is_a? Window }
  end
end
