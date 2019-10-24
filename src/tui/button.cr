require "./widget"
require "./widget/menu_item"

class TUI::Button < TUI::Widget::MenuItem
  property label : String?
  property activated : Proc(Nil)

  def initialize(parent : Widget? = nil, lab = "Unset Label", &block)
    super(parent, lab)
    @activated = block
    bind MouseStatus::PrimaryClick do |e|
      set_focused true
      activated.call
      true
    end
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
