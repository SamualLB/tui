# Handles main loop, selections, dispersing events
class TUI::Application
  @backend : Backend
  @main_window : Window

  property stop = false

  getter! start_time : Time::Span
  getter! end_time : Time::Span

  @painter : Painter?

  def initialize(main_window : Class | Window = Window, backend : Backend | Class | Nil = nil)
    @main_window = case main_window
    when Window then main_window
    else             main_window.new
    end
    @backend = case backend
    when Backend then backend
    when Class   then backend.new
    else              Backend::DEFAULT.new
    end
    @main_window.app = self
    TUI.logger.info "Application init"
  end

  # Main loop
  def exec
    @start_time = Time.monotonic
    TUI.logger.info "Exec started"
    @backend.start
    loop do
      # poll events

      # TODO: Need to add a way to limit redraws
      #
      # frame rate / libevent
      dispatch_draw if (Time.monotonic - start_time) <= 2.5.seconds
      break if @stop
      break if (Time.monotonic - start_time) >= 5.seconds
      #raise "aaaah" if (Time.monotonic - start_time) >= 2.5.seconds
    end
  rescue ex
    TUI.logger.fatal ex
  ensure
    @backend.stop
    @end_time = Time.monotonic
    TUI.logger.info "Exec ended"
    TUI.dump_log
  end

  private def painter : Painter
    @painter ||= Painter.new(@backend.width, @backend.height)
  end

  private def dispatch_draw
    event = Event::Draw.new(painter)
    raise "redraw error!" unless @main_window.handle(event)
    @backend.paint(painter)
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
