class TUI::Layout::Stacked < TUI::Layout
  @index : Int32 | Nil = nil

  @widgets = [] of Widget

  # Sets selected widget to full screen
  def set(event, rect)
    @widgets.each_with_index do |win, i|
      if i == @index
        win.rect = Rect.new(rect.w, rect.h)
      else
        win.rect = Rect.new(0, 0)
      end
      win.handle(event)
    end
  end

  def <<(win : Widget)
    delete(win)
    @widgets << win
    @index = 0 if @widgets.size == 1
  end

  def delete(win : Widget)
    @widgets.delete win
  end

  def top? : Widget?
    return nil unless i = @index
    @widgets[i]?
  end

  def top : Widget
    @widgets[@index.as(Int32)]
  end

  def index : Int32
    @index.not_nil!
  end

  def index=(i : Int32)
    unless i < @widgets.size && i >= 0
      raise "invalid stacked layout index #{i}/#{@widgets.size-1}"
    end
    @index = i
    widget.app.dispatch_resize
  end

  def each_widget(&block)
    @widgets.each { |win| yield win if win.is_a? Widget }
  end
end
