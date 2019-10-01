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
    end
  end

  def <<(window : Window)
    @windows << window
    @index = 0 if @windows.size == 1
  end

  def top? : Window?
    return nil unless @index
    @windows[@index]?
  end

  def top : Window
    @windows[@index.as(Int32)]
  end

  def index=(new : Int32)
    @index = new
    window.app.dispatch_resize
  end
end
