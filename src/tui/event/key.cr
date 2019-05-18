struct TUI::Event::Key < TUI::Event
  @k : TUI::Key | Char | Nil
  
  def key
    @k.not_nil!
  end

  protected def key=(new_k : TUI::Key | Char)
    @k = new_k
  end
end
