class TUI::Label
  include TUI::Painter

  property! text : String

  def initialize(@text) end

  def paint(surface : TUI::Surface)
    text.chars.each_with_index do |ch, i|
      cell = TUI::Cell.new(ch)
      surface[{i, 0}] = cell
    end
    self
  end

  def min_size
    {text.size, 1}
  end

  def size?
    min_size
  end

  def max_size
    {Int32.max, Int32.max}
  end
end
