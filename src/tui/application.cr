require "./event_loop"

# Handles main loop, selections, dispersing events
class TUI::Application
  include EventLoop

  property fps : Int32 | Float64
  getter previous_draw : Time::Span = 0.seconds
  @parent_stack = [] of Window
  @backend : Backend
  @window : Window
  @callbacks = Deque({start: Time::Span, run: Time::Span, proc: Proc(Nil)}).new

  getter focused : Window?

  def initialize(main_window : Class | Window, backend : Backend | Class | Nil = nil,first_focus : Window? = nil , *, @fps = 5, title : String? = nil)
    @window = case main_window
    when Window then main_window
    else             main_window.new
    end
    @backend = case backend
    when Backend then backend
    when Class   then backend.new
    else              Backend::DEFAULT.new
    end
    TUI.logger.info "Application init"
    @window.app = self
    first_focus.set_focused(true) if first_focus
    self.title = title if title
  end

  # Main loop
  def exec
    TUI.logger.info "Application exec started, starting backend"
    @backend.start
    painter # Generate
    super
  ensure
    TUI.logger.info "Application exec ended, stopping backend"
    @backend.stop
    TUI.dump_log
  end

  # returns true when valid event dispatched
  #
  # false on invalid Event class or nil
  protected def dispatch(event : Event?) : Bool
    case event
    when Event::Key then dispatch_key(event)
    when Event::Mouse then dispatch_mouse(event)
    when Event::Resize then dispatch_resize(event)
    else return false
    end
    true
  end

  # Create a draw event and disperse it to the main window
  # to go down the window tree
  protected def dispatch_draw
    event_time = Time.monotonic
    painter.clear
    event = Event::Draw.new(painter, @previous_draw - event_time)
    raise "redraw error!" unless @window.handle(event)
    @backend.paint(painter)
    @previous_draw = event_time
  end

  # Pass to the currently focused window, which will then
  # bubble the event up until it is consumed or reaches the
  # top of the tree
  private def dispatch_key(event : Event::Key)
    unless focus = focused
      focus = @window
      TUI.logger.info "No window focused for key event, using top-level #{focus}"
    end
    unless focus.handle(event)
      TUI.logger.info "Unhandled key event #{event}, sent to #{focus}"
    end
  end

  # Find the window the event takes place in and pass it,
  # which wil then bubble the event up until it is
  # consumed or reaches the top of the tree
  #
  # TODO: does not really handle click and hold events
  # if the mouse moves from when it was pressed to where it is
  # released
  private def dispatch_mouse(event : Event::Mouse)
    # find containing window that is lowest down the tree,
    # store in cur_window
    cur_window = @window
    loop do
      parent_window = cur_window
      break if cur_window.block_mouse_events?
      cur_window.layout.each_window do |child|
        if child.contains(event)
          cur_window = child
          break
        end
      end
      break if parent_window == cur_window # no child contains, parent only
    end
    unless cur_window.handle(event)
      TUI.logger.info "Unhandled mouse event #{event}, sent to: #{cur_window}"
    end
  end

  def dispatch_resize(event : Event::Resize)
    TUI.logger.info "resize dispatched"
    raise "resize error!" unless @window.handle(event)
  end

  def dispatch_resize
    dispatch_resize Event::Resize.new(@backend.width, @backend.height)
  end

  def callback(span : Time::Span, &block : Proc(Nil)) : self
    call_time = Time.monotonic
    @callbacks << {start: call_time, run: call_time + span, proc: block}
    self
  end

  def check_callbacks : Bool
    cur_time = Time.monotonic
    @callbacks.each do |tup|
      next unless cur_time >= tup[:run]
      @callbacks.delete(tup)
      tup[:proc].call
      return true
    end
    false
  end

  def reparent(new_parent : Window)
    old_parent = @window
    old_parent.parent = new_parent
    new_parent.parent = nil
    new_parent.app = self
    new_parent << old_parent
    @window = new_parent
    @parent_stack.push old_parent
  end

  def deparent
    old_parent = @window
    new_parent = @parent_stack.pop
    new_parent.parent = nil
    old_parent.layout.delete(new_parent)
    @window = new_parent
  end

  protected def painter : Painter
    raise "Backend not started" unless @backend.started
    @painter ||= Painter.new(@backend.width, @backend.height)
  end

  def app : Application
    self
  end

  def focused! : Window
    @focused.not_nil!
  end

  def focused=(win : Window?)
    return if win == focused
    old_focus = focused
    @focused = win
    win.try &.focused = true
    old_focus.try &.focused = false
    TUI.logger.info "Set new focus: #{@focused}"
  end

  delegate :title=, to: @backend
  delegate :poll, to: @backend
end
