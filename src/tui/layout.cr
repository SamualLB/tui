require "./widget"

abstract class TUI::Layout
  getter! widget : Widget

  def widget=(@widget)
    @widget.layout = self unless @widget.layout == self
    parent_sub_widgets
  end

  def initialize(@widget)
    parent_sub_widgets
  end

  private def parent_sub_widgets
    each_widget { |w| w.parent =  widget unless w.parent}
  end

  # Yield each widget that is mouse accessible
  #
  # Overriden to stop mouse presses for modals
  def each_widget_mouse(&block : Widget -> Nil)
    each_widget { |w| yield w }
  end

  # Add a widget with default values at least
  abstract def <<(win : Widget)

  # Define to set the actual layout
  abstract def set(event, rect : Rect)

  # Used to build draw tree
  abstract def each_widget(&block : Widget -> Nil)

  abstract def delete(win : Widget)
end

require "./layout/*"
