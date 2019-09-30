abstract class TUI::Window
  property! w : Int32
  property! h : Int32
  property! x : Int32
  property! y : Int32

  property children = [] of Window

  getter parent : Window?

  setter layout : Layout?
  setter app : Application?

  def initialize(@parent = nil)
    parent.children << self if parent
  end

  def app : Application
    @app ||= parent!.app
  end

  def layout : Layout
    @layout ||= Layout::DEFAULT.new
  end

  def parent! : Window
    @parent.not_nil!
  end

  def parent=(new_parent)
    @parent = new_parent
    new_parent.children << self if new_parent
  end

  #abstract def handle(event : Event::Key) : Bool
  #abstract def handle(event : Event::Mouse) : Bool

  def handle(event : Event::Resize) : Bool
    self.x = 0
    self.y = 0
    self.w = event.width
    self.h = event.height
    children.each { |child| return false unless child.handle(event) }
    true
  end

  abstract def paint(surface : Painter)

  # Temporary implementation
  #
  # Needs to make use of layout
  def handle(event : Event::Draw) : Bool
    return false unless paint(event.painter)
    children.each do |child|
      event.painter.push(child.x, child.y, child.w, child.h)
      return false unless child.handle(event)
      event.painter.pop
    end
    true
  end
end
