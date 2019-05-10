class TUI::Root
  property! painter : TUI::Painter
  property! surface : TUI::Surface
  property! backend : TUI::Backend

  def initialize(@backend, @painter, @surface) end

  def initialize(@backend, @painter)
    @surface = Surface.new(backend.width, backend.height)
  end

  def loop
    loop do
      backend.print(painter.paint(surface))
    end
  end
end
