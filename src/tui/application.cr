# Handles main loop, selections, dispersing events
class TUI::Application
  @backend : Backend
  @main_window : Window

  property stop = false
  property fps : Int32 | Float64

  getter! start_time : Time::Span
  getter! end_time : Time::Span

  @painter : Painter?
  @previous_draw : Time::Span

  @modals = [] of Window

  def initialize(main_window : Class | Window = Window, backend : Backend | Class | Nil = nil, *, @fps = 30)
    @main_window = case main_window
    when Window then main_window
    else             main_window.new
    end
    @backend = case backend
    when Backend then backend
    when Class   then backend.new
    else              Backend::DEFAULT.new
    end
    @previous_draw = 0.seconds
    @main_window.app = self
    TUI.logger.info "Application init"
  end

  # Main loop
  def exec
    @start_time = Time.monotonic
    TUI.logger.info "Exec started"
    @backend.start
    loop do
      current_time = Time.monotonic
      # TODO: poll events
      dispatch_draw if (current_time - @previous_draw) >= (1 / fps).seconds
      break if @stop
      if @modals.empty? && (current_time - start_time) >= 2.5.seconds
        @modals << NotepadPopup.new
      end
      break if (current_time - start_time) >= 5.seconds
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

  # Create a draw event and disperse it to the main window
  # to go down the window tree
  #
  # After the main window tree, it is passed to the current modal,
  # if it exists
  private def dispatch_draw
    event_time = Time.monotonic
    event = Event::Draw.new(painter, @previous_draw - event_time)
    TUI.logger.info "draw call initiated"
    raise "redraw error!" unless @main_window.handle(event)
    @modals.last?.try &.handle(event)
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
