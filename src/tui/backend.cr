abstract class TUI::Backend
  abstract def start : self

  abstract def stop : self

  abstract def width : Int32

  abstract def height : Int32

  abstract def draw(cell : TUI::Cell, x : Int32, y : Int32) : self

  abstract def refresh : self

  abstract def clear : self
end

require "./backend/*"
