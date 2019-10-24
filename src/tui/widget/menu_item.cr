class TUI::Widget::MenuItem < TUI::Widget
  property label : String?

  def initialize(parent : Widget? = nil, @label = nil)
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

  def to_s(io : IO)
    io << "#<" << self.class.name << ":0x"
    object_id.to_s(16, io)
    io << " \"" << label << "\"" << '>'
  end
end
