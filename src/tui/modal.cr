require "./window"

abstract class TUI::Modal < TUI::Window
  include EventLoop

  def initialize(@app : Application)
  end

  def exec
    TUI.logger.info "Modal exec started #{self}"
    app.reparent(self)
    super
    TUI.logger.info "Modal exec ended #{self}"
    app.deparent
  end

  def self.exec(app : Application)
    self.new(app).exec
  end

  def block_mouse_events?
    true
  end
end
