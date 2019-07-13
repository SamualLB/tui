require "./../src/tui/*"
require "./../src/tui/backend/ncurses"

backend = TUI::Backend::NCurses.new

overlay = TUI::Overlay.new

text = TUI::Label.new("Running...")

bg = TUI::Fill.new(' ')

overlay.background = bg
overlay.foreground = text

err = nil
begin
  backend.start
  surface = TUI::Surface.new(backend.width, backend.height)
  loop do
    backend.clear
    overlay.paint(surface).print(backend)
    backend.refresh
    inp = backend.poll
    case inp
    when TUI::Event::Key
      break if inp.key == 'q'
      text.text = "#{inp.key} (#{inp.time})"
    when TUI::Event::Mouse
      text.text = "#{inp.mouse} (#{inp.position}) (#{inp.time})"
    end
  end
rescue ex
  err = ex
ensure
  backend.stop
end

p err if err
pp err.backtrace if err
