abstract class TUI::Window
  property! w : Int32
  property! h : Int32
  property! x : Int32
  property! y : Int32

  getter parent : Window?

  setter layout : Layout?
  setter app : Application?

  property focused : Bool = false

  def initialize(@parent = nil)
    parent << self if parent
  end

  def app : Application
    @app ||= parent!.app
  end

  def layout : Layout
    @layout ||= Layout::Horizontal.new(self)
  end

  def parent! : Window
    @parent.not_nil!
  end

  def parent=(new_parent)
    @parent = new_parent
    new_parent.layout << self if new_parent
  end

  def <<(win : Window)
    layout << win
  end

  #abstract def handle(event : Event::Key) : Bool
  #abstract def handle(event : Event::Mouse) : Bool

  def handle(event : Event::Resize) : Bool
    unless parent
      self.x = 0
      self.y = 0
      self.w = event.width
      self.h = event.height
    end
    layout.set(event, w, h)
    true
  end

  abstract def paint(surface : Painter)

  def handle(event : Event::Draw) : Bool
    return false unless paint(event.painter)
    layout.each_window do |child|
      event.painter.push(child.x, child.y, child.w, child.h)
      return false unless child.handle(event)
      event.painter.pop
    end
    true
  end

  def set_focused(val : Bool)
    if val
      app.focused = self
    else
      app.focused = nil if app.focused == self
    end
  end

  # TODO: Bubble up
  # TODO: Implement key bindings and key method
  def handle(event : Event::Key) : Bool
    layout.each_window do |child|
      return true if child.handle(event)
    end
    false
  end

  # TODO: Bubble up
  def handle(event : Event::Mouse) : Bool
    false
  end

  def block_mouse_events? : Bool
    false
  end

  protected def contains(event : Event::Mouse) : Bool
    event.x >= x && event.y >= y && event.x < x+w && event.y < y+h
  end
end
