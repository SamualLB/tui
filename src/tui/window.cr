abstract class TUI::Window
  property parent : Window?
  property! w : Int32
  property! h : Int32
  property! x : Int32
  property! y : Int32

  property! layout : Layout

  def initialize(@parent = nil)

  end

  #abstract def handle(event : Event::Key) : Bool
  #abstract def handle(event : Event::Mouse) : Bool
  #abstract def handle(event : Event::Resize) : Bool
end
