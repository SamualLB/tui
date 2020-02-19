abstract class TUI::Widget::Modal < TUI::Widget
  @holder : Widget::ModalHolder?

  def initialize(@app : Application)
  end

  def self.exec(app : Application)
    # create holder
    # set as child
    # reparent to holder
    # exec event loop on holder
    holder = Widget::ModalHolder.new(app)
    modal = self.new(app)
    modal.holder = holder
    holder.top = modal
    holder.exec
  end

  def holder=(w : Widget::ModalHolder)
    @holder = w
  end

  def holder
    @holder.not_nil!
  end

  delegate :stop, to: holder
end
