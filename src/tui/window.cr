abstract class TUI::Window
  property! rect : Rect

  getter parent : Window?

  setter layout : Layout?
  setter app : Application?

  property focused : Bool = false

  @key_bindings = {} of Key | Char => Proc(Event::Key, Bool)
  @mouse_bindings = {} of MouseStatus => Proc(Event::Mouse, Bool)

  def initialize(@parent = nil)
    parent << self if parent
    bind(MouseStatus::PrimaryClick) { |e| set_focused true; true }
  end

  # Overwrite to handle other unknown key presses
  def key(event : Event::Key) : Bool
    false
  end

  # Overwrite to handle other unknown mouse events
  def mouse(event : Event::Mouse) : Bool
    false
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

  # Override to draw in the widget
  def paint(surface : Painter) : Bool
    true
  end

  def handle(event : Event::Resize) : Bool
    if parent.nil?
      self.rect = Rect.new(event.width, event.height)
    end
    layout.set(event, rect)
    true
  end

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

  # Handle an event:
  #
  # * Firstly see if it has been bound
  # * Secondly pass to the overwritable key method
  # * Then pass to the parent recursively
  #
  # When there are no parent, false is returned and the event
  # is left unhandled
  def handle(event : Event::Key) : Bool
    # Find key binding and run
    @key_bindings[event.key]?.try { |bind| return true if bind.call(event) }
    # Run generic key method
    return true if key(event)
    # Pass to parent
    return true if parent.try &.handle(event)
    false
  end

  # ditto
  def handle(event : Event::Mouse) : Bool
    @mouse_bindings[event.mouse]?.try { |bind| return true if bind.call(event) }
    return true if mouse(event)
    return true if parent.try &.handle(event)
    false
  end

  def block_mouse_events? : Bool
    false
  end

  protected def contains(event : Event::Mouse) : Bool
    event.x >= x && event.y >= y && event.x < x+w && event.y < y+h
  end

  def bind(key : Key | Char, &block : Event::Key -> Bool) : self
    @key_bindings[key] = block
    self
  end

  def unbind(key : Key | Char) : self
    @key_bindings.delete(key)
    self
  end

  def unbind_keys : self
    @key_bindings.clear
    self
  end

  def bind(mouse : MouseStatus, &block : Event::Mouse -> Bool) : self
    @mouse_bindings[mouse] = block
    self
  end

  def unbind(mouse : MouseStatus) : self
    @mouse_bindings.delete(mouse)
    self
  end

  def unbind_mouse : self
    @mouse_bindings.clear
    self
  end

  def unbind_all : self
    @key_bindings.clear
    @mouse_bindings.clear
    self
  end

  delegate x, y, w, h, to: rect
end

require "./window/*"
