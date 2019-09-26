require "./event_loop"

# Handles main loop, selections, dispersing events
class TUI::Application
  include EventLoop
  @painter : Painter?

  def initialize(main_window : Class | Window = Window, backend : Backend | Class | Nil = nil, *, fps = 30)
    main_window = case main_window
    when Window then main_window
    else             main_window.new
    end
    backend = case backend
    when Backend then backend
    when Class   then backend.new
    else              Backend::DEFAULT.new
    end
    TUI.logger.info "Application init"
    super(main_window, backend, fps: fps)
    main_window.app = self
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
end
