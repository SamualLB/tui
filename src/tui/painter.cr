module TUI::Painter
  abstract def paint(surface : TUI::Surface) : TUI::Surface
  abstract def min_size : {Int32, Int32}
  abstract def size? : {Int32, Int32}?
  abstract def max_size : {Int32, Int32}
end
