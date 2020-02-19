# Helper widget for the Stacked layout
class TUI::Widget::Stacked < TUI::Widget
  def initialize(parent : Widget? = nil)
    super
    @layout = Layout::Stacked.new(self)
  end

  def layout : Layout::Stacked
    @layout.as(Layout::Stacked)
  end

  def layout=(l)
    unless l.is_a?(Layout::Stacked)
      raise ArgumentError.new(
        "Stacked widget layout can only by Layout::Stacked, not #{l.class}")
    end
    @layout = l
  end

  def index=(i : Int32)
    self.dirty = true if i != layout.index
    layout.index = i
  end

  delegate index, to: layout
end
