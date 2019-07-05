# Provides a surface that can be drawn on
#
# Can create sub-surface on part of the surface
struct TUI::Surface
  property! size : Tuple(Int32, Int32)

  @cells = {} of {Int32, Int32} => Cell

  forward_missing_to @cells

  def initialize(x, y)
    @size = {x, y}
  end

  def initialize(xy : {x: Int32, y: Int32})
    @size = {xy[:x], xy[:y]}
  end

  def initialize(@size)
  end

  def w : Int32
    size[0]
  end

  def h : Int32
    size[1]
  end

  protected def sub(w, h, offset_x = 0, offset_y = 0, &block)
    s = TUI::Surface.new(w, h)
    yield s
    s.w.times do |w|
      s.h.times do |h|
        newval = s[{w, h}]?
        self[{w+offset_x, h+offset_y}] = newval if newval
      end
    end
  end

  protected def sub(w, h, offset : Tuple(Int32, Int32), &block)
    sub(w, h, offset[0], offset[1]) { |s| yield s }
  end

  protected def sub(*, offset_x : Int32, offset_y : Int32, &block)
    new_w = w - offset_x
    new_h = h - offset_y
    sub(new_w, new_h, offset_x, offset_y) { |s| yield s }
  end

  protected def sub(*, offset : Tuple(Int32, Int32), &block)
    new_w, new_h = w - offset[0], h - offset[1]
    sub(new_w, new_h, offset[0], offset[1]) { |s| yield s }
  end

  def print(backend : TUI::Backend)
    h.times do |h|
      w.times do |w|
        v = self[{w, h}]?
        backend.draw(v, w, h) if v
      end
    end
    backend.refresh
  end
end
