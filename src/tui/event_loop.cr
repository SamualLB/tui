module TUI::EventLoop
  @backend : Backend
  @window : Window

  property stop = false
  property fps : Int32 | Float64

  getter! start_time : Time::Span
  getter! end_time : Time::Span

  @previous_draw : Time::Span

  @modal_shown = false

  def initialize(@window, @backend, *, @fps = 30, @painter = nil)
    @previous_draw = 0.seconds
    TUI.logger.info "Event loop init #{@window}"
  end

  # Main loop
  def exec
    @start_time = Time.monotonic
    TUI.logger.info "Event loop exec started #{@window}"
    loop do
      current_time = Time.monotonic
      # TODO: poll events
      # TODO: sleep when no events are available and waiting for next frame draw
      dispatch_draw if (current_time - @previous_draw) >= (1 / fps).seconds
      if self.is_a?(Application) && !@modal_shown && (current_time - start_time) >= 2.5.seconds
        TUI.logger.info "Starting the notepad test modal"
        @modal_shown = true
        NotepadPopup.exec(self)
      end
      break if @stop
      break if (current_time - start_time) >= 5.seconds
    end
  rescue ex
    TUI.logger.fatal "Event loop exec error: #{ex} on #{@window}"
  ensure
    @end_time = Time.monotonic
    TUI.logger.info "Event loop exec ended #{@window}"
  end

  private def painter : Painter
    @painter ||= Painter.new(@backend.width, @backend.height)
  end

  # Create a draw event and disperse it to the main window
  # to go down the window tree
  #
  # Currently looks if there is an application to draw the background of
  #
  # TODO: find a better way to draw the main application window when
  # in a modal loop
  private def dispatch_draw
    event_time = Time.monotonic
    painter.clear
    event = Event::Draw.new(painter, @previous_draw - event_time)
    TUI.logger.info "draw call initiated #{@window}"
    unless self.is_a?(Application)
      @window.app.@window.handle(event)
    end
    raise "redraw error!" unless @window.handle(event)
    @backend.paint(painter)
    @previous_draw = event_time
  end

  private def dispatch_resize
    # resize all widgets
    raise "unimplemented"
  end

  private def dispatch_key
    # dispatch key event
    raise "unimplemented"
  end

  private def dispatch_mouse
    # dispatch mouse event
    raise "unimplemented"
  end
end
