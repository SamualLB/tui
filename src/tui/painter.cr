# Created by the application, passed down the widget tree by using `#push`
# to alter relative coordinates
#
# When drawing use `#w` and `#h` for actual size
#
# Use `#pop` after drawing
class TUI::Painter
  getter surface : Array(Array(Cell))

  # Current rect
  @current_rect : Rect

  # {x, y, w, h} offsets
  @stack = [] of Rect

  def w : Int32
    @current_rect.w
  end

  def h : Int32
    @current_rect.h
  end

  def initialize(w, h)
    @current_rect = Rect.new(w, h)
    @surface = Array.new(w) { Array.new(h) { Cell.new } }
  end

  def initialize(wh : {Int32, Int32})
    @current_rect = Rect.new(wh[0], wh[1])
    @surface = Array.new(wh[0]) { Array.new(wh[1]) { Cell.new } }
  end

  def resize(w, h) : self
    @current_rect = Rect.new(w, h)
    @surface = Array.new(w) { Array.new(h) { Cell.new } }
    @stack.clear
    self
  end

  def diff(old : Array(Array(Cell))? = nil, &block) : Bool
    return false unless old
    return false if old.size != surface.size || old[0].size != surface[0].size
    each_with_index do |cell, i, j|
      yield cell, i, j if cell != old[i][j]
    end
    true
  end

  # Push new offsets onto stack
  #
  # Optional arguments can set a maximum width
  def push(new_x, new_y, new_w = Int32::MAX, new_h = Int32::MAX) : self
    if new_x < 0 || new_y < 0 || new_w < 0 || new_h < 0
      raise ArgumentError.new("Negative value given: #{new_x}, #{new_y}, #{new_w}, #{new_h}")
    end
    @stack << @current_rect
    @current_rect = Rect.new(
      @current_rect.x + new_x,
      @current_rect.y + new_y,
      Math.max(0, Math.min(new_w, w - new_x)),
      Math.max(0, Math.min(new_h, h - new_y)))
    self
  end

  # Pop offsets from stack
  def pop : self
    return self if @stack.empty?
    @current_rect = @stack.pop
    self
  end

  def each(&block)
    w.times { |i| h.times { |j| yield self[i, j] } }
  end

  def each_with_index(&block)
    w.times { |i| h.times { |j| yield self[i, j], i, j } }
  end

  def each_index(&block)
    w.times { |i| h.times { |j| yield i, j } }
  end

  def clear : self
    each_index { |i, j| self[i, j] = Cell.new }
    self
  end

  def clear(rect) : self
    (rect.x...(rect.x+rect.w)).each do |i|
      (rect.y...(rect.y+rect.h)).each do |j|
        self[i, j] = Cell.new
      end
    end
    self
  end

  def []?(i, j) : Cell?
    # handle negative indexes by starting from the end
    i += w if i < 0
    j += h if j < 0
    return nil unless
        i < w &&
        j < h &&
        i >= 0 &&
        j >= 0
    @surface[@current_rect.x+i][@current_rect.y+j]
  end

  def [](i, j) : Cell
    self[i, j]? || raise IndexError.new
  end

  def []=(i, j, val : Cell)
    i += w if i < 0
    j += h if j < 0
    return nil unless
        i < w &&
        j < h &&
        i >= 0 &&
        j >= 0
    @surface[@current_rect.x+i][@current_rect.y+j] = val
  end

  def []=(i, j, val : Char)
    self[i, j] = Cell.new(val)
  end

  # Draw a string `str`
  #
  # Starting at point [`i`, `j`], with maximum `width`
  def []=(i, j, width, str : String)
    x_extra = 0
    y_extra = 0
    str.each_char do |c|
      if c == '\n'
        x_extra = 0
        y_extra += 1
        next
      end
      self[i+x_extra, j+y_extra] = c
      x_extra += c.width
      if x_extra >= width
        x_extra = 0
        y_extra += 1
      end
    end
  end

  # Draw a string `str`
  #
  # Starting at point [`i`, `j`], up to maximum width
  def []=(i, j, str : String)
    self[i, j, w-i] = str
  end


  def print(i, j, str : String)
    self[i, j] = str
  end

  def centre(mid, j, str : String)
    self[mid-str.width//2, j] = str
  end

  def to_s(io : IO)
    io << "Current rect: #{@current_rect}. "
    io << "Stack: " << @stack
  end

  def line(x0 : Int32, y0 : Int32, x1 : Int32, y1 : Int32, ch : Char = '█', debug = false) : self
    dx = (x1 - x0).abs
    sx = x0 < x1 ? 1 : -1
    dy = -(y1 - y0).abs
    sy = y0 < y1 ? 1 : -1
    err = dx + dy
    ch = '0' if debug
    loop do
      self[x0, y0] = ch
      break if x0 == x1 && y0 == y1
      e2 = 2 * err
      if e2 >= dy
        err += dy
        x0 += sx
      end
      if e2 <= dx
        err += dx
        y0 += sy
      end
      ch = ch.succ if debug
      ch = '1' if debug && ch == ':'
    end
    self
  end
  def vline(x0 : Int32, y0 : Int32, len : Int32, ch : Char = '█', debug = false) : self
    ch = '0' if debug
    until len == 0
      self[x0, y0] = ch
      diff = len < 0 ? 1 : -1
      y0 -= diff
      len += diff
      ch = ch.succ if debug
      ch = '1' if debug && ch == ':'
    end
    self
  end


  def hline(x0 : Int32, y0 : Int32, len : Int32, ch : Char = '█', debug = false) : self
    ch = '0' if debug
    until len == 0
      self[x0, y0] = ch
      diff = len < 0 ? 1 : -1
      x0 -= diff
      len += diff
      ch = ch.succ if debug
      ch = '1' if debug && ch == ':'
    end
    self
  end

  # TODO: do not set negative coordinate values
  def circle(x0 : Int32, y0 : Int32, radius : Int32 = 5, ch : Char = '█', debug = false) self
    ch = '0' if debug
    self[x0, y0 + radius] = ch
    self[x0, y0 - radius] = ch
    self[x0 + radius, y0] = ch
    self[x0 - radius, y0] = ch

    f = 1 - radius
    ddf_x = 1
    ddf_y = -2 * radius
    x = 0
    y = radius
    while x < y
      if f >= 0
        y -= 1
        ddf_y += 2
        f += ddf_y
      end
      x += 1
      ddf_x += 2
      f += ddf_x
      ch = ch.succ if debug
      self[x0 + x, y0 + y] = ch
      self[x0 + x, y0 - y] = ch
      self[x0 - x, y0 + y] = ch
      self[x0 - x, y0 - y] = ch
      self[x0 + y, y0 + x] = ch
      self[x0 + y, y0 - x] = ch
      self[x0 - y, y0 + x] = ch
      self[x0 - y, y0 - x] = ch
    end
    self
  end

  def rect(x0 : Int32, y0 : Int32, x1 : Int32, y1 : Int32, ch : Char = '█', debug = false) : self
    ch = '0' if debug
    hline(x0, y0, x1-x0, ch)
    ch = ch.succ if debug
    vline(x0, y0, y1-y0, ch)
    ch = ch.succ if debug
    hline(x0, y1, x1-x0, ch)
    ch = ch.succ if debug
    vline(x1, y0, y1-y0, ch)
    self[x1, y1] = ch
    self
  end

  # Draws a polygon with points specified in separate arrays of x and y coordinates
  def poly(x_points : Array(Int32), y_points : Array(Int32), ch : Char = '█', debug = false) : self
    unless x_points.size == y_points.size
      raise ArgumentError.new(
        "non-matching number of points for #poly: #{x_points.size} & #{y_points.size}")
    end
    ch = '0' if debug
    x_points.size.times do |i|
      line(x_points[i], y_points[i], x_points[i+1], y_points[i+1], ch)
      ch = ch.succ if debug
      break if i == x_points.size-2
    end
    line(x_points.last, y_points.last, x_points.first, y_points.first, ch)
    self
  end

  # Draws a polygon with points specified as an array of coordinate tuples
  def poly(points : Array(Tuple(Int32, Int32)), ch : Char = '█', debug = false) : self
    poly(Array.new(points.size) { |i| points[i][0] }, Array.new(points.size) { |i| points[i][1] }, ch, debug)
  end
end
