module TUI::EventLoop
  @backend : Backend
  @window : Window
  @painter : Painter?

  property stop = false
  property fps : Int32 | Float64

  getter! start_time : Time::Span
  getter! end_time : Time::Span

  @previous_draw : Time::Span

  @modal_drawn = false # temp, for notepad popup test

  def initialize(@window, @backend, *, @fps = 30)
    @previous_draw = 0.seconds
    TUI.logger.info "Event loop init #{@window}"
  end

  # Main loop
  def exec
    @start_time = Time.monotonic
    TUI.logger.info "Event loop exec started #{@window}"
    dispatch_resize
    loop do
      while Time.monotonic < @previous_draw + (1 / fps).seconds
        handled = dispatch_event(@backend.poll)
        sleep(@previous_draw + (1 / fps).seconds - Time.monotonic) unless handled
      end
      dispatch_draw
      {% if env("NOTEPAD_TEST") %}
      if self.is_a?(Application) && !@modal_drawn && (Time.monotonic - start_time) >= 2.5.seconds
        TUI.logger.info "Starting the notepad test modal"
        @modal_drawn = true
        NotepadPopup.exec(self)
      end
      {% elsif env("STACK_TEST") %}
      if self.is_a?(Application) && !@modal_drawn && (Time.monotonic - start_time) >= 2.5.seconds
        TUI.logger.info "Swapping stack"
        @modal_drawn = true
        @window.@layout.as(Layout::Stacked).index = 1
      end
      {% end %}
      break if @stop
      break if (Time.monotonic - start_time) >= 5.seconds
    end
  rescue ex
    TUI.logger.fatal "Event loop exec error: #{ex} on #{@window}"
    TUI.logger.fatal ex.inspect_with_backtrace
  ensure
    @end_time = Time.monotonic
    TUI.logger.info "Event loop exec ended #{@window}"
  end

  private def painter : Painter
    raise "Backend not started" unless @backend.started
    @painter ||= Painter.new(@backend.width, @backend.height)
  end

  # returns true when valid event found
  #
  # false on invalid Event class or nil
  private def dispatch_event(event : Event?) : Bool
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
  def dispatch_draw
    event_time = Time.monotonic
    painter.clear
    event = Event::Draw.new(painter, @previous_draw - event_time)
    TUI.logger.info "draw call initiated #{@window}"
    raise "redraw error!" unless @window.handle(event)
    @backend.paint(painter)
    @previous_draw = event_time
  end

  # Pass to the currently focused window, which will then
  # bubble the event up until it is consumed or reaches the
  # top of the tree
  private def dispatch_key(event : Event::Key)
    unless focus = app.focused
      focus = @window
      TUI.logger.info "No window focused for key event, using top-level #{focus}"
    end
    unless focus.handle(event)
      TUI.logger.info "Unhandled key event #{event}, sent to #{focus}"
    end
  end

  private def dispatch_mouse(event : Event::Mouse)
    # find contaning window that is lowest down the tree, store in cur_window
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
    TUI.logger.info "Sending mouse event #{event} to #{cur_window}"
    unless cur_window.handle(event)
      TUI.logger.info "Unhandled mouse event #{event}, sent to #{cur_window}"
    end
  end

  def dispatch_resize(event : Event::Resize? = nil)
    event = Event::Resize.new(@backend.width, @backend.height) unless event
    TUI.logger.info "resize dispatched"
    raise "resize error!" unless @window.handle(event)
  end

  abstract def app : Application
end
