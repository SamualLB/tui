abstract struct TUI::Border
  # Draw border and push an inner rect for the widget
  abstract def paint(painter : Painter)
end

require "./border/*"
