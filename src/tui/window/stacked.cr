# Helper window for the Stacked layout
class TUI::Window::Stacked < TUI::Window
  def initialize(parent : Window? = nil)
    super
    @layout = Layout::Stacked.new(self)
  end

  def layout : Layout::Stacked
    @layout.as(Layout::Stacked)
  end

  def layout=(l)
    unless l.is_a?(Layout::Stacked)
      raise ArgumentError.new(
        "Stacked window layout can only by Layout::Stacked, not #{l.class}")
    end
    @layout = l
  end
end