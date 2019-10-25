struct TUI::Border::Custom < TUI::Border
  @proc : Proc(Painter, Nil)

  def initialize(&block : Painter -> Nil)
    @proc = block
  end

  def paint(painter : Painter)
    @proc.call(painter)
  end
end
