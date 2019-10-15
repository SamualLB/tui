module TUI::EventLoop
  property stop = false

  getter! start_time : Time::Span
  getter! end_time : Time::Span

  # Main loop
  def exec
    @start_time = Time.monotonic
    app.dispatch_resize
    loop do
      while Time.monotonic < (app.previous_draw + (1.0 / app.fps).seconds)
        handled = false
        handled = true if app.check_callbacks
        handled = true if app.dispatch(app.poll)
        sleep(app.previous_draw + (1 / app.fps).seconds - Time.monotonic) unless handled
      end
      app.dispatch_draw
      break if @stop
    end
  rescue ex
    TUI.logger.fatal "Event loop exec error: #{ex} on #{self}"
    TUI.logger.fatal ex.inspect_with_backtrace
  end

  abstract def app : Application

  delegate painter, to: app
end
