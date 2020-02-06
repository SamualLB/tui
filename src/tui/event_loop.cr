module TUI::EventLoop
  property stop = false

  getter! start_time : Time::Span
  getter! end_time : Time::Span

  # Main loop
  def exec
    @start_time = Time.monotonic
    app.dispatch_resize
    loop do
      app.dispatch_draw
      ev = app.channel.receive
      app.dispatch ev
      break if @stop
    end
  rescue ex
    TUI.logger.fatal "Event loop exec error: #{ex} on #{self}"
    TUI.logger.fatal ex.inspect_with_backtrace
  end

  abstract def app : Application

  delegate painter, to: app
end
