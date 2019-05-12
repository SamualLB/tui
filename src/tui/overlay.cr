class TUI::Overlay
  include TUI::Painter

  property! background : TUI::Painter
  property! foreground : TUI::Painter
  property! anchor : TUI::Anchor

  def initialize
    @anchor = Anchor::Center
  end

  def initialize(@background, @foreground, @anchor = Anchor::Center)
  end

  def paint(surface : TUI::Surface) : TUI::Surface
    surface.sub(surface.w, surface.h) { |s| background.paint s }
    coords = calc_coords(surface.size)
    surface.sub(coords[0], coords[1], coords[2], coords[3]) { |s| foreground.paint s }
    surface
  end

  def min_size() background.min_size end
  def size?() background.size? end
  def max_size() background.max_size end

  private def calc_coords(sur : {Int32, Int32}) : {Int32, Int32, Int32, Int32}
    sz = foreground.size? || foreground.min_size
    off =  case anchor
    when Anchor::TopLeft then {0, 0}
    when Anchor::Top     then {(sur[0]-sz[0])/2, 0}
    when Anchor::TopRight then {sur[0]-sz[0], 0}
    when Anchor::Left     then {0, (sur[1]-sz[1])/2}
    when Anchor::Center  then {(sur[0]-sz[0])/2, (sur[1]-sz[1])/2}
    when Anchor::Right    then {sur[0]-sz[0], (sur[1]-sz[1])/2}
    when Anchor::BottomLeft  then {0, sur[1]-sz[1]}
    when Anchor::Bottom      then {(sur[0]-sz[0])/2, sur[1]-sz[1]}
    when Anchor::BottomRight then {sur[0]-sz[0], sur[1]-sz[1]}
    else raise "Unknown anchor point #{anchor}"
    end
    {sz[0], sz[1], off[0], off[1]}
  end
end
