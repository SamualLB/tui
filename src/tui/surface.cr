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

  protected def sub(w, h, x = 0, y = 0, &block)
    s = TUI::Surface.new(w, h)
    yield s
    s.w.times do |w|
      s.h.times do |h|
        newval = s[{w, h}]?
        self[{w+x, h+y}] = newval if newval
      end
    end
  end

  protected def sub(w, h, xy : Tuple(Int32, Int32), &block)
    sub(w, h, xy[0], xy[1]) { |s| yield s }
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
