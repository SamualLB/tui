require "./../src/tui/*"
require "./../src/tui/backend/*"

count = 1

{% for back_class in TUI::Backend.all_subclasses %}
  backend = {{back_class}}.new
  overlay = TUI::Overlay.new

  text = TUI::Label.new("Running #{count}...")

  err = nil
  begin
    backend.start
    surface = TUI::Surface.new(backend.width, backend.height)
    text.paint(surface).print(backend)
    sleep 2.5
    polled = backend.poll true
    polled2 = backend.poll true
  rescue ex
    err = ex
  ensure
    backend.stop
  end

  p err if err
  pp err.backtrace if err

  p polled
  p polled2
  puts

  count += 1
{% end %}
