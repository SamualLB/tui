struct TUI::Event::Draw < TUI::Event
  getter painter : TUI::Painter

  def initialize(@painter)
    super()
  end
end
