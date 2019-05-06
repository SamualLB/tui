require "./tui/*"
require "./tui/backend/termbox"

module TUI
  VERSION = "0.0.1"

  backend = TUI::Backend::Termbox.new.start
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

  
  err = nil
  begin
    backend.start
    surface = TUI::Surface.new(backend.width, backend.height)
    split.paint(surface).print(backend)
    sleep 5
  rescue ex
    err = ex
  ensure
    backend.stop
  end
  puts err if err
end


