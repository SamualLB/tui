require "./../src/tui/*"
require "./../src/tui/backend/*"

{% for back_class in TUI::Backend.all_subclasses %}
  backend = {{back_class}}.new
  overlay = TUI::Overlay.new

  bg = TUI::Fill.new('○')
  overlay.background = bg

  fg_parent = TUI::Fixed.new
  fg_parent.size = {10, 10}

  fg = TUI::Custom.new
  fg.proc = -> (s : TUI::Surface) do
    s.w.times do |w|
      s.h.times do |h|
        c = TUI::Cell.new
        c.char = w > h ? w.to_s[0] : h.to_s[0]
        s[{w, h}] = c
      end
    end
    s
  end

  overlay.foreground = fg_parent
  overlay.anchor = TUI::Anchor::Top
  fg_parent.child = fg

  err = nil
  begin
    backend.start
    surface = TUI::Surface.new(backend.width, backend.height)
    overlay.paint(surface).print(backend)
    sleep 2.5
  rescue ex
    err = ex
  ensure
    backend.stop
  end

  p err if err
  pp err.backtrace if err

{% end %}
