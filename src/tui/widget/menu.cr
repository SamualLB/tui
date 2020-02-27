class TUI::Widget::Menu < TUI::Widget
  def initialize(parent : Widget? = nil)
    super
    @layout = Layout::Menu.new(self)
  end

  def layout : Layout::Menu
    @layout.as(Layout::Menu)
  end

  def layout=(l)
    unless l.is_a?(Layout::Menu)
      raise ArgumentError.new(
        "Menu layout can only be MenuLayout, not #{l.class}")
    end
    @layout = l
  end

  def height
    max = 1
    layout.@items.each do |item|
      i_height = item.height
      max = i_height if i_height && i_height > max
    end
    max
  end
end
