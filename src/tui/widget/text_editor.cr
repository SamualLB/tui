class TUI::Widget::TextEditor < TUI::Widget
  BLINK_RATE = 0.5

  @line_buffer = [] of String
  @cur_pos = {0, 0}
  @on_empty = false

  property tab_size = 4

  def initialize(parent : Widget? = nil)
    super
    @line_buffer << "Default text"
    @cur_pos = {5, 0}
    unbind 'q'
    bind(Key::Escape) { app.stop = true }
  end

  private def cur_line : String
    @line_buffer[@cur_pos[1]]
  end

  # Prevent negative wrapping
  private def prev_line : String?
    ind = @cur_pos[1]-1
    return nil unless ind >= 0
    @line_buffer[ind]?
  end

  private def next_line : String?
    @line_buffer[@cur_pos[1]+1]?
  end

  private def cur_line=(val : String)
    @line_buffer[@cur_pos[1]] = val
  end

  def key(event : Event::Key)
    case k = event.key
    when Key::Right then cursor_right
    when Key::Left then cursor_left
    when Key::Up then cursor_up
    when Key::Down then cursor_down
    when Key::Backspace then backspace
    when Key::Delete then delete
    when '\n' then newline
    when '\t' then tab
    when Char then insert k
    else return false
    end
    true
  end

  private def insert(ch : Char | String)
    if @on_empty
      @line_buffer << ""
      @on_empty = false
    end
    line = cur_line
    str_start = line[...@cur_pos[0]]
    str_end = line[@cur_pos[0]..]
    self.cur_line = str_start + ch + str_end
    @cur_pos = {@cur_pos[0] + ch.bytesize, @cur_pos[1]}
  end

  private def cursor_right
    if @cur_pos[0] < self.cur_line.bytesize
      @cur_pos = {@cur_pos[0] + 1, @cur_pos[1]}
    else
      @on_empty = true unless next_line
      @cur_pos = {0, @cur_pos[1]+1}
    end
  end

  private def cursor_left
    if @cur_pos[0] > 0
      @cur_pos = {@cur_pos[0] - 1, @cur_pos[1]}
    else
      @cur_pos = {0, Math.max(0, @cur_pos[1]-1)}
    end
  end

  private def cursor_down
    return if @on_empty
    return unless @cur_pos[1] < @line_buffer.size
    return if @cur_pos[1] == @line_buffer.size && cur_line == ""
    max_x_pos = (@line_buffer[@cur_pos[1]+1]?.try &.bytesize) || 0
    @cur_pos = {Math.min(@cur_pos[0], max_x_pos), @cur_pos[1] + 1}
    @on_empty = @line_buffer[@cur_pos[1]]?.nil?
  end

  private def cursor_up
    return unless @cur_pos[1] > 0
    @cur_pos = {Math.min(@cur_pos[0], @line_buffer[@cur_pos[1]-1].bytesize), @cur_pos[1] - 1}
  end

  private def newline
    if @on_empty
      @line_buffer << ""
    end
    line = cur_line
    str_start = line[...@cur_pos[0]]
    str_end = line[@cur_pos[0]..]
    self.cur_line = str_start
    @cur_pos = {0, @cur_pos[1] + 1}
    @line_buffer.insert(@cur_pos[1], str_end)
  end

  private def tab
    (tab_size - @cur_pos[0] % 4).times { insert ' ' }
  end

  private def backspace
    line = cur_line
    if line.empty?
      # remove line, go to end of previous
      @line_buffer.delete_at @cur_pos[1]
      prev = prev_line
      if prev
        @cur_pos = {prev.bytesize, @cur_pos[1]-1}
      else
        @cur_pos = {0, @cur_pos[1]}
      end
    elsif @cur_pos[0] == 0
      # append current line to previous
      prev_l = prev_line
      self.cur_line = (prev_l || "") + line
      @line_buffer.delete_at(@cur_pos[1]-1) if prev_l
      @cur_pos = {prev_l ? prev_l.bytesize : 0, @cur_pos[1]-1} if prev_l
    else
      self.cur_line = line[...@cur_pos[0]-1] + line[(@cur_pos[0])..]
      @cur_pos = {@cur_pos[0]-1, @cur_pos[1]}
    end
  end

  private def delete
    line = cur_line
    if line.empty?
      @line_buffer.delete_at @cur_pos[1]
    elsif @on_empty
      return
    elsif line.bytesize == @cur_pos[0]
      next_l = @line_buffer[@cur_pos[1]+1]?
      self.cur_line = line + (next_l || "")
      @line_buffer.pop if next_l
    else
      self.cur_line = line[...@cur_pos[0]] + line[(@cur_pos[0]+1)..]
    end
  end

  def paint(painter : TUI::Painter)
    @line_buffer.each_with_index do |line, i|
      painter[0, i] = line
    end
    if (Time.monotonic.to_f % (BLINK_RATE * 2)) > BLINK_RATE
      painter[@cur_pos[0], @cur_pos[1]] = '█'
    end
    true
  end

  def lines : Array(String)
    @line_buffer
  end

  def as_s : String
    return "" if @line_buffer.empty?
    String.build do |s|
      @line_buffer.each do |l|
        s << l
        {% if flag?(:win32) %}
          s << "\r\n"
        {% else %}
          s << '\n'
        {% end %}
      end
    end
  end
end
