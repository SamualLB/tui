require "./../src/tui/*"
require "./../src/tui/backend/*"

{% for back_class in TUI::Backend.all_subclasses %}
backend = {{back_class}}.new
split = TUI::HorizontalSplit.new

l = TUI::Fill.new('L')
split.left = l

r_parent = TUI::Fixed.new
r_parent.size = {10, 10}

r = TUI::Fill.new('R')

split.right = r_parent
r_parent.child = r

err = nil
begin
  backend.start
  surface = TUI::Surface.new(backend.width, backend.height)
  split.paint(surface).print(backend)
  sleep 2.5
rescue ex
  err = ex
ensure
  backend.stop
end
p err if err
pp err.backtrace if err
{% end %}
