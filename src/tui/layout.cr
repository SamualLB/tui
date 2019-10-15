require "./window"

abstract class TUI::Layout
  getter! window : Window

  def window=(@window)
    @window.layout = self unless @window.layout == self
    parent_sub_windows
  end

  def initialize(@window)
    parent_sub_windows
  end

  private def parent_sub_windows
    each_window { |w| w.parent =  window unless w.parent}
  end

  # Add a window with default values at least
  abstract def <<(win : Window)

  # Define to set the actual layout
  abstract def set(event, w, h)

  # Used to build draw tree
  abstract def each_window(&block : Window -> Nil)

  abstract def delete(win : Window)
end

require "./layout/*"
