module TUI::EventLoop
  property stop = false

  getter! start_time : Time::Span
  getter! end_time : Time::Span

  @modal_drawn = false # temp, for notepad popup test

  def initialize()
    TUI.logger.info "Event loop init #{self}"
  end

  # Main loop
  def exec
    @start_time = Time.monotonic
    TUI.logger.info "Event loop exec started #{self}"
    app.dispatch_resize
    loop do
      while Time.monotonic < (app.previous_draw + (1.0 / app.fps).seconds)
        handled = app.dispatch(app.poll)
        sleep(app.previous_draw + (1 / app.fps).seconds - Time.monotonic) unless handled
      end
      app.dispatch_draw
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
        app.@window.layout.as(Layout::Stacked).index = 1
      end
      {% end %}
      break if @stop
      break if (Time.monotonic - start_time) >= 5.seconds
    end
  rescue ex
    TUI.logger.fatal "Event loop exec error: #{ex} on #{self}"
    TUI.logger.fatal ex.inspect_with_backtrace
  ensure
    @end_time = Time.monotonic
    TUI.logger.info "Event loop exec ended #{self}"
  end

  abstract def app : Application

  delegate painter, to: app
end
