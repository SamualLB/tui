struct TUI::Event::Draw < TUI::Event
  getter painter : TUI::Painter
  getter elapsed_time : Time::Span

  def initialize(@painter, @elapsed_time)
    super()
  end
end
