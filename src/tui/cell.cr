struct TUI::Cell
  property char = ' '

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
