module TUI::Painter
  abstract def paint(surface : TUI::Surface) : TUI::Surface

#  abstract def handle_mouse(surface : TUI::Surface, mouse : TUI::Event::Mouse) : Bool
#  abstract def handle_key(surface : TUI::Surface, key : TUI::Event::Key) : Bool

  abstract def min_size : {Int32, Int32}
  abstract def size? : {Int32, Int32}?
  abstract def max_size : {Int32, Int32}
end
