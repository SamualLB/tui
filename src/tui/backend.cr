abstract class TUI::Backend
  DEFAULT = NCurses

  abstract def start : self

  abstract def stop : self

  abstract def width : Int32

  abstract def height : Int32

  abstract def draw(cell : TUI::Cell, x : Int32, y : Int32) : self

  abstract def refresh : self

  abstract def clear : self

  abstract def poll(timeout : Int32 | Bool = false) : TUI::Event?

  def paint(painter : TUI::Painter)
    painter.h.times do |h|
      painter.w.times do |w|
        draw(painter[w, h], w, h)
      end
    end
    refresh
  end
end

require "./backend/*"
