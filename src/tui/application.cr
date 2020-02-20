require "./event_loop"

# Handles main loop, selections, dispersing events
class TUI::Application
  include EventLoop

  @previous_draw : Time::Span = 0.seconds
  @parent_stack = [] of Widget
  @backend : Backend
  @widget : Widget

  getter focused : Widget?
  getter hover : Widget?

  def initialize(main_widget : Class | Widget, backend : Backend | Class | Nil = nil,first_focus : Widget? = nil , *, title : String? = nil)
    @widget = case main_widget
    when Widget then main_widget
    else             main_widget.new
    end
    @backend = case backend
    when Backend then backend
    when Class   then backend.new
    else              Backend::DEFAULT.new
    end
    @widget.app = self
    first_focus.set_focused(true) if first_focus
    self.title = title if title
  end

  # Main loop
  def exec
    @backend.start
    painter # Generate
    super
  ensure
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

  # Create a draw event and disperse it to the main widget
  # to go down the widget tree
  def dispatch_draw
    event_time = Time.monotonic
    painter.clear
    event = Event::Draw.new(painter, @previous_draw - event_time)
    raise "redraw error!" unless @widget.handle(event)
    #@backend.clear
    @backend.paint(painter)
    @previous_draw = event_time
  end

  # Pass to the currently focused widget, which will then
  # bubble the event up until it is consumed or reaches the
  # top of the tree
  private def dispatch_key(event : Event::Key)
    unless focus = focused
      focus = @widget
      TUI.logger.info "No widget focused for key event, using top-level #{focus}"
    end
    unless focus.handle(event)
      TUI.logger.info "Unhandled key event #{event}, sent to #{focus}"
    end
  end

  # Find the widget the event takes place in and pass it,
  # which wil then bubble the event up until it is
  # consumed or reaches the top of the tree
  #
  # TODO: does not really handle click and hold events
  # if the mouse moves from when it was pressed to where it is
  # released
  private def dispatch_mouse(event : Event::Mouse)
    # find containing widget that is lowest down the tree,
    # store in cur_widget
    cur_widget = @widget
    loop do
      parent_widget = cur_widget
      cur_widget.layout.each_widget_mouse do |child|
        if child.contains?(event)
          cur_widget = child
          break
        end
      end
      break if parent_widget == cur_widget # no child contains, parent only
    end
    unless cur_widget.handle(event) || event.mouse == TUI::MouseStatus::Position
      TUI.logger.info "Unhandled mouse event #{event}, sent to: #{cur_widget}"
    end
  end

  def dispatch_resize(event : Event::Resize)
    painter.resize(event.width, event.height)
    raise "resize error!" unless @widget.handle(event)
  end

  def dispatch_resize
    dispatch_resize Event::Resize.new(@backend.width, @backend.height)
  end

  def reparent(new_parent : Widget)
    old_parent = @widget
    old_parent.parent = new_parent
    new_parent.parent = nil
    new_parent.app = self
    new_parent << old_parent
    @widget = new_parent
    @parent_stack.push old_parent
  end

  def deparent
    old_parent = @widget
    new_parent = @parent_stack.pop
    new_parent.parent = nil
    old_parent.layout.delete(new_parent)
    @widget = new_parent
    @widget.dirty = true
  end

  protected def painter : Painter
    raise "Backend not started" unless @backend.started
    @painter ||= Painter.new(@backend.width, @backend.height)
  end

  def app : Application
    self
  end

  def focused! : Widget
    @focused.not_nil!
  end

  def focused=(w : Widget?)
    return if w == focused
    old_focus = focused
    @focused = w
    w.try &.focused = true
    old_focus.try &.focused = false
  end

  def hover! : Widget
    @hover.not_nil!
  end

  def hover=(w : Widget?)
    return if w == hover
    old_hover = hover
    @hover = w
    if w && w.hover.nil?
      raise ArgumentError.new "Widget does not have hover coordinates"
    end
    old_hover.try &.hover = nil
  end

  def dirty? : Bool
    @widget.dirty?
  end

  delegate :title=, to: @backend
  delegate :poll, to: @backend
end
