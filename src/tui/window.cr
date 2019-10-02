abstract class TUI::Window
  property! w : Int32
  property! h : Int32
  property! x : Int32
  property! y : Int32

  getter parent : Window?

  setter layout : Layout?
  setter app : Application?

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
    layout.each_window do |child|
      event.painter.push(child.x, child.y, child.w, child.h)
      return false unless child.handle(event)
      event.painter.pop
    end
    return false unless paint(event.painter)
    true
  end
end
