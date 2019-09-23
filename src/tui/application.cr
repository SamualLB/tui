# Handles main loop, selections, dispersing events
class TUI::Application
  @backend : Backend
  @main_window : Window

  property stop = false

  getter! start_time : Time::Span
  getter! end_time : Time::Span

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
  end

  # Main loop
  def exec
    @start_time = Time.monotonic
    STDERR.puts "Started: #{start_time}"
    @backend.start
    loop do
      # poll events
      # paint
      break if @stop
      break if (Time.monotonic - start_time) >= 5.seconds
      raise "aaaah" if (Time.monotonic - start_time) >= 2.5.seconds
    end
  rescue ex
    PrettyPrint.format(ex, STDERR, 79)
    STDERR.puts
    sleep 2.5
  ensure
    @backend.stop
    @end_time = Time.monotonic
    STDERR.puts "Ended: #{end_time}"
  end
end
