require "./menu_item"

class TUI::Widget::Button < TUI::Widget::MenuItem
  property activated : Proc(Nil)

  def initialize(parent : Widget? = nil, lab = "Unset Label", &block)
    super(parent, lab)
    @activated = block
    bind MouseStatus.flags(PrimaryClick, PrimaryRelease, PrimaryDoubleClick) do |e|
      set_focused true
      activated.call
      true
    end
  end
end
