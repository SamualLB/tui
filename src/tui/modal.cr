require "./widget"

abstract class TUI::Modal < TUI::Widget
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

  def handle(event : Event::Draw) : Bool
    layout.each_widget do |child|
      event.painter.push(child.x, child.y, child.w, child.h)
      return false unless child.handle(event)
      event.painter.pop
    end
    border.paint(event.painter)
    return false unless paint(event.painter)
    event.painter.pop
    true
  end
end
