abstract struct TUI::Border
  # Draw border and push an inner rect for the widget
  abstract def paint(painter : Painter)

  abstract def width : Int32?

  abstract def width(h : Int32) : Int32?

  abstract def height : Int32?

  abstract def height(w : Int32) : Int32?
end

require "./border/*"
