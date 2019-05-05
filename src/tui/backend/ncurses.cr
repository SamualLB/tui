require "ncurses"

class TUI::Backend::NCurses < TUI::Backend
  def start
    ::NCurses.start
    self
  end

  def stop
    ::NCurses.end
    self
  end

  def width : Int32
    ::NCurses.width
  end

  def height : Int32
    ::NCurses.height
  end

  def draw(cell : TUI::Cell, x : Int32, y : Int32) : self
    ::NCurses.print(cell.char.to_s, y, x)
    self
  end

  def refresh
    ::NCurses.refresh
    self
  end

  def clear
    ::NCurses.clear
    self
  end
end
