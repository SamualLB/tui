require "./../widget/main"

class TUI::Layout::MainWindow < TUI::Layout

  @top_menu : Widget::Menu?
  @main_widget : Widget?
  @bottom_menu : Widget::Menu?

  def set(event, rect)
    leftover_h = rect.h
    @top_menu.try do |t|
      t.rect = Rect.new(0, 0, rect.w, 1)
      leftover_h -= 1
      t.handle(event)
    end
    @bottom_menu.try do |b|
      b.rect = Rect.new(0, rect.h-1, rect.w, 1)
      leftover_h -= 1
      b.handle(event)
    end
    @main_widget.try do |m|
      m.rect = Rect.new(0, @top_menu ? 1 : 0, rect.w, leftover_h)
      m.handle(event)
    end
  end

  def top=(win : Widget::Menu)
    @top_menu = win
  end

  def bottom=(win : Widget::Menu)
    @bottom_menu = win
  end

  def <<(win : Widget)
    return if @top_menu == win
    return if @bottom_menu == win
    @main_widget = win
  end

  def delete(win : Widget)
    @top_menu = nil if win == @top_menu
    @main_widget = nil if win == @main_widget
    @bottom_menu = nil if win == @bottom_menu
  end

  def each_widget(&block)
    @top_menu.try { |w| yield w }
    @main_widget.try { |w| yield w }
    @bottom_menu.try { |w| yield w }
  end
end
