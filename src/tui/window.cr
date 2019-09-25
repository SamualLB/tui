abstract class TUI::Window
  property! parent : Window
  property! w : Int32
  property! h : Int32
  property! x : Int32
  property! y : Int32

  property children = [] of Window

  setter layout : Layout?
  setter app : Application?

  def initialize(@parent = nil)
    parent.children << self if parent
  end

  def app : Application
    @app ||= parent.app
  end

  def layout : Layout
    @layout ||= Layout::DEFAULT.new
  end

  #abstract def handle(event : Event::Key) : Bool
  #abstract def handle(event : Event::Mouse) : Bool
  #abstract def handle(event : Event::Resize) : Bool

  abstract def paint(surface : Painter)

  def handle(event : Event::Draw) : Bool
    paint(event.painter)
    true
  end
end
