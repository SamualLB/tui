abstract class TUI::Layout
  getter! window : Window

  def window=(@window)
    @window.layout = self unless @window.layout == self
  end

  def initialize(@window)
  end

  # Define to set the actual layout
  abstract def set(event, w, h)
end

require "./layout/*"
