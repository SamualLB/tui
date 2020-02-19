require "./modal"

class TUI::Widget::MessageBox < TUI::Widget::Modal
  def initialize(app : TUI::Application)
    super(app)
    @layout = Layout::MessageBox.new(self)
  end

  def layout : Layout::MessageBox
    @layout.as(Layout::MessageBox)
  end

  def layout=(l)
    unless l.is_a?(Layout::MessageBox)
      raise ArgumentError.new(
        "MessageBox layout can only be MessageBox, not #{l.class}")
    end
    @layout = l
  end

  def handle(event : Event::Draw) : Bool
    event.painter.clear
    super
  end
end
