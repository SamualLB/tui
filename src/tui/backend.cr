abstract class TUI::Backend
  abstract def start : self

  abstract def stop : self

  abstract def width : Int32

  abstract def height : Int32

  abstract def draw(cell : TUI::Cell, x : Int32, y : Int32) : self

  abstract def refresh : self

  abstract def clear : self

  def paint(surface : TUI::Surface)
    surface.h.times do |h|
      surface.w.times do |w|
        v = surface.@cells[{w, h}]?
        draw(v, w, h) if v
      end
    end
    refresh
  end
end

require "./backend/*"
