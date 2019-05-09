require "./../src/tui/*"
require "./../src/tui/backend/*"

backend = TUI::Backend::NCurses.new
split = TUI::HorizontalSplit.new

l = TUI::Custom.new
l.proc = ->(s : TUI::Surface) do
  s.w.times do |w|
    s.h.times do |h|
      c = TUI::Cell.new
      c.char = 'L'
      s.@cells[{w, h}] = c
    end
  end
  s
end
split.left = l

r_parent = TUI::Fixed.new
r_parent.size = {10, 10}

r = TUI::Custom.new
r.proc = ->(s : TUI::Surface) do
  s.w.times do |w|
    s.h.times do |h|
      c = TUI::Cell.new
      c.char = 'R'
      s.@cells[{w, h}] = c
    end
  end
  s
end

split.right = r_parent
r_parent.child = r

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
pp err if err
