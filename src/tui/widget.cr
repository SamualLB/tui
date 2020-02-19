abstract class TUI::Widget
  property! rect : Rect

  getter parent : Widget?

  setter layout : Layout?
  setter app : Application?
  setter border : Border?

  property focused : Bool = false
  property hover : {Int32, Int32}?
  getter dirty : Bool = true

  @key_bindings = {} of Key | Char => Proc(Event::Key, Bool)
  @mouse_bindings = {} of MouseStatus => Proc(Event::Mouse, Bool)

  def initialize(@parent = nil)
    parent << self if parent
    bind(MouseStatus::PrimaryClick) { |e| set_focused true; true }
    bind(MouseStatus::Position) { |e| set_hover e; true }
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

  def border : Border
    @border ||= Border::None.new
  end

  def parent! : Widget
    @parent.not_nil!
  end

  def parent=(new_parent)
    @parent = new_parent
    new_parent.layout << self if new_parent
  end

  def <<(win : Widget)
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
    border.paint(event.painter)
    return false unless paint(event.painter)
    layout.each_widget do |child|
      event.painter.push(child.x, child.y, child.w, child.h)
      return false unless child.handle(event)
      event.painter.pop
    end
    event.painter.pop
    @dirty = false
    true
  end

  def set_focused(val : Bool)
    if val
      app.focused = self
    else
      app.focused = nil if app.focused == self
    end
  end

  def tree_focused? : Bool
    return true if focused
    layout.each_widget do |child|
      return true if child.tree_focused?
    end
    false
  end

  def set_hover(e : Event::Mouse)
    raise ArgumentError.new "Incorrect mouse event sent to set_hover #{e.mouse}" unless e.mouse == MouseStatus::Position
    set_hover({e.x-self.x, e.y-self.y})
  end

  def set_hover(xy : {Int32, Int32}?)
    return if xy == hover
    self.dirty = true
    if xy
      @hover = xy
      app.hover = self
    else
      app.hover = nil if app.hover == self
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
    event.mouse.each { |m| @mouse_bindings[m]?.try { |bind| return true if bind.call(event) } }
    return true if mouse(event)
    return true if parent.try &.handle(event)
    false
  end

  protected def contains?(event : Event::Mouse) : Bool
    self.rect.contains?(event.x, event.y)
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
    mouse.each { |m| @mouse_bindings[m] = block }
    self
  end

  def unbind(mouse : MouseStatus) : self
    mouse.each { |m| @mouse_bindings.delete(mouse) }
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

  def dirty? : Bool
    @dirty
  end

  def dirty=(v : Bool)
    return @dirty = false if v == false
    @dirty = true
    if (p = @parent)
      p.dirty = true
    end
  end

  def dump_tree_rect(io : IO, e : Event::Mouse, far = 0)
    io << '\n'
    io << " "*far
    io << "#{self} rect: #{rect}. #{rect.contains?(e.position[0], e.position[1])}"
    layout.each_widget &.dump_tree_rect(io, e, far+1)
  end

  delegate x, y, w, h, to: rect
end

require "./widget/*"
