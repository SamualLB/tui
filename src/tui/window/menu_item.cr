class TUI::Window::MenuItem < TUI::Window
  property label : String?

  def initialize(parent : Window? = nil, @label = nil)
    super(parent)
  end

  def paint(painter : TUI::Painter)
    label.try { |l| painter[0, 0] = l }
    true
  end

  def label_width : Int32
    label.try { |l| return l.bytesize }
    0
  end
end
