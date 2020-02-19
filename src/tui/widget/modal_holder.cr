class TUI::Widget::ModalHolder < TUI::Widget
  include EventLoop

  def initialize(@app : Application)
    @layout = Layout::Modal.new(self)
  end

  def exec
    TUI.logger.info "Modal exec started #{self}"
    app.reparent(self)
    super
    TUI.logger.info "Modal exec ended #{self}"
    app.deparent
    app.focused = nil if tree_focused?
  end

  def layout : Layout::Modal
    @layout.as(Layout::Modal)
  end

  def layout=(l)
    unless l.is_a?(Layout::Modal)
      raise ArgumentError.new(
        "Modal Holder layout can only by Layout::Modal, not #{l.class}")
    end
    @layout = l
  end

  # Override to send directly to top window
  def handle(event : Event::Key) : Bool
    layout.@top.try { |w| return w.handle(event) }
    false
  end

  delegate :top=, :bottom=, to: layout
end
