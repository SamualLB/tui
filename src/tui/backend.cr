# Backends must create a fiber that loops infinitely to send events
# to `channel`
abstract class TUI::Backend
  DEFAULT = NCurses

  getter started = false
  
  @channel : Channel(TUI::Event)
  @prev_paint : Array(Array(Cell))? = nil

  def initialize
    @channel = Channel(TUI::Event).new
  end

  abstract def start : self

  abstract def stop : self

  abstract def width : Int32

  abstract def height : Int32

  abstract def draw(cell : TUI::Cell, x : Int32, y : Int32) : self

  abstract def refresh : self

  abstract def clear : self

  def poll : TUI::Event
    @channel.receive
  end

  def paint(painter : TUI::Painter)
    #drawn = painter.diff(@prev_paint) do |c, x, y|
    #  draw(c, x, y)
    #end
    #unless drawn
      painter.h.times do |h|
        painter.w.times do |w|
          draw(painter[w, h], w, h)
        end
      end
    #end
    refresh
    @prev_paint = painter.surface.dup
  end

  # XTerm compatible
  def title=(str : String)
    print("\033]2;", str, "\007")
  end
end

require "./backend/*"
