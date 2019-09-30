require "./event_loop"

# Handles main loop, selections, dispersing events
class TUI::Application
  include EventLoop

  @parent_stack = [] of Window

  def initialize(main_window : Class | Window = Window, backend : Backend | Class | Nil = nil, *, fps = 30, title : String? = nil)
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

  def reparent(new_parent : Window)
    old_parent = @window
    old_parent.parent = new_parent
    new_parent.parent = nil
    new_parent.app = self
    @parent_stack.push old_parent
  end

  def deparent
    @window = @parent_stack.pop
  end

  delegate :title=, to: @backend
end
