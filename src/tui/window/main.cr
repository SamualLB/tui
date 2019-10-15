# Helper window for the Stacked layout
class TUI::Window::Main < TUI::Window
  def initialize(parent : Window? = nil)
    super
    @layout = Layout::MainWindow.new(self)
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
end
