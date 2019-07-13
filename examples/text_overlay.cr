require "./../src/tui/*"
require "./../src/tui/backend/*"

{% for back_class in TUI::Backend.all_subclasses %}
  backend = {{back_class}}.new
  overlay = TUI::Overlay.new

  bg = TUI::Fill.new('◯')
  overlay.background = bg

  fg = TUI::Label.new("Dip can provide benefits!")

  overlay.foreground = fg
  overlay.anchor = TUI::Anchor::Center

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
