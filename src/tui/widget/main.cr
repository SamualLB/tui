# Helper widget for the Stacked layout
class TUI::Widget::Main < TUI::Widget
  def initialize(parent : Widget? = nil)
    super
    @layout = Layout::MainWindow.new(self)
    bind('q') do
      app.stop
      true
    end
  end

  def layout : Layout::MainWindow
    @layout.as(Layout::MainWindow)
  end

  def layout=(l)
    unless l.is_a?(Layout::MainWindow)
      raise ArgumentError.new(
        "Main window layout can only by Layout::MainWindow, not #{l.class}")
    end
    @layout = l
  end

  def <<(win : Widget)
  end

  delegate :top=, :bottom=, to: layout
end
