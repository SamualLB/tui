class TUI::Widget::MenuItem < TUI::Widget
  property label : String?

  def initialize(parent : Widget? = nil, @label = nil)
    super(parent)
  end

  def paint(painter : TUI::Painter)
    label.try { |l| painter[0, 0] = l }
    true
  end

  def width : Int32
    (l = label) ? l.width + ((b = @border) ? b.width || 0 : 0) : 0
  end

  def height
    (b = @border) ? b.height + (label ? 1 : 0) : (label ? 1 : 0)
  end

  def to_s(io : IO)
    io << "#<" << self.class.name << ":0x"
    object_id.to_s(io, 16)
    io << " \"" << label << "\"" << '>'
  end
end
