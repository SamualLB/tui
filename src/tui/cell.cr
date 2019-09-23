struct TUI::Cell
  DEFAULT_CHAR = ' '

  property char = DEFAULT_CHAR

  def initialize() end
  def initialize(@char) end

  #property style = Style.new

  #struct Style
  #  property fg : Color
  #  property bg : Color
  #  property reverse : Bool
  #  property bold : Bool
  #  property underline : Bool
  #end
end
