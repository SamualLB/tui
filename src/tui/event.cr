abstract struct TUI::Event
  @t : Time? = nil

  def initialize
    @t = Time.utc
  end

  def time
    @t.not_nil!
  end

  protected def time=(new_t : Time)
    @t = new_t
  end
end

require "./event/*"
