# Created by the application, passed down the widget tree by using `#push`
# to alter relative coordinates
#
# When drawing use `#w` and `#h` for actual size
#
# Use `#pop` after drawing
class TUI::Painter
  @surface : Array(Array(Cell))

  @global_w : Int32
  @global_h : Int32

  # Current rect
  @offset_x = 0
  @offset_y = 0
  getter w : Int32
  getter h : Int32

  # {x, y, w, h} offsets
  @stack = [] of {Int32, Int32, Int32, Int32}

  def initialize(w, h)
    @w = @global_w = w
    @h = @global_h = h
    @surface = Array.new(w) { Array.new(h) { Cell.new } }
  end

  def initialize(wh : {Int32, Int32})
    @w = @global_w = wh[0]
    @h = @global_h = wh[1]
    @surface = Array.new(wh[0]) { Array.new(wh[1]) { Cell.new } }
  end

  def resize(w, h) : self
    @w = @global_w = w
    @h = @global_h = h
    @surface = Array.new(w) { Array.new(h) { Cell.new } }
    @stack.clear
    self
  end

  # Push new offsets onto stack
  #
  # Optional arguments can set a maximum width
  def push(new_x, new_y, new_w = Int32::MAX, new_h = Int32::MAX) : self
    if new_x < 0 || new_y < 0 || new_w < 0 || new_h < 0
      raise ArgumentError.new("Negative value given: #{new_x}, #{new_y}, #{new_w}, #{new_h}")
    end
    prev_x, prev_y, prev_w, prev_h = @offset_x, @offset_y, w, h
    @stack.push({prev_x, prev_y, prev_w, prev_h})
    @offset_x += new_x
    @offset_y += new_y
    @w = Math.max(0, Math.min(new_w, prev_w - new_x))
    @h = Math.max(0, Math.min(new_h, prev_h - new_y))
    self
  end

  # Pop offsets from stack
  #
  # TODO: raises when stack is empty?
  def pop : self
    @offset_x, @offset_y, @w, @h = @stack.pop
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

  def []?(i, j) : Cell?
    # handle negative indexes by starting from the end
    i += w if i < 0
    j += h if j < 0
    return nil unless
        i < w &&
        j < h &&
        i >= 0 &&
        j >= 0
    @surface[@offset_x+i][@offset_y+j]
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
    @surface[@offset_x+i][@offset_y+j] = val
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
      x_extra += 1
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
end
