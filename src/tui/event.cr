abstract struct TUI::Event
  @t : Time::Span

  def initialize
    @t = Time.monotonic
  end

  def time
    @t.not_nil!
  end

  protected def time=(new_t : Time::Span)
    @t = new_t
  end
end

require "./event/*"
