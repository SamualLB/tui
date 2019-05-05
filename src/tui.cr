require "./tui/*"
require "./tui/backend/ncurses"

module TUI
  VERSION = "0.0.1"

  backend = TUI::Backend::NCurses.new.start
  split = TUI::HorizontalSplit.new()
  l = TUI::Custom.new()
  l.proc = ->(s : TUI::Surface) do
    s.w.times do |w|
      s.h.times do |h|
        c = Cell.new()
        c.char = 'L'
        s.@cells[{w, h}] = c
      end
    end
    s
  end
  split.left = l
  r = TUI::Custom.new()
  r.proc = ->(s : TUI::Surface) do
    s.w.times do |w|
      s.h.times do |h|
        c = Cell.new()
        c.char = 'R'
        s.@cells[{w, h}] = c
      end
    end
    s
  end
  split.right = r;

  surface = TUI::Surface.new(backend.width, backend.height)
  
  backend.start
  split.paint(surface).print(backend)
  sleep 5
  backend.stop
end


