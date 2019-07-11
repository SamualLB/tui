require "ncurses"

class TUI::Backend::NCurses < TUI::Backend
  ERR = -1
  OK = 0

  def start
    ::NCurses.start
    ::NCurses.keypad true
    ::NCurses.mouse_mask(::NCurses::Mouse::AllEvents | ::NCurses::Mouse::Position)
    self
  end

  def stop
    ::NCurses.end
    self
  end

  def width : Int32
    ::NCurses.width
  end

  def height : Int32
    ::NCurses.height
  end

  def draw(cell : TUI::Cell, x : Int32, y : Int32) : self
    ::NCurses.print(cell.char.to_s, y, x)
    self
  end

  def refresh
    ::NCurses.refresh
    self
  end

  def clear
    ::NCurses.clear
    self
  end

  def poll(timeout : Int32 | Bool = false) : TUI::Event?
    return nil unless event = ::NCurses.get_char
    case event
    when ::NCurses::Key::Mouse then
      return nil if (LibNCurses.getmouse(out mouse)) == ERR
      return map_mouse(::NCurses::MouseEvent.new(mouse))
    when ::NCurses::Key::Resize then
      TUI::Event::Resize.new({width, height})
    else
      #return ::TUI::Event::Key.new
      return map_key(event)
    end
  end

  private def map_key(event : ::NCurses::Key | Char) : TUI::Event::Key?
    out_event = TUI::Event::Key.new
    out_event.key = case event
    when Char then event
    when ::NCurses::Key::Up    then TUI::Key::Up
    when ::NCurses::Key::Down  then TUI::Key::Down
    when ::NCurses::Key::Left  then TUI::Key::Left
    when ::NCurses::Key::Right then TUI::Key::Right
    else
      STDERR.puts "Unhandled NCurses key #{event}"
      return nil
    end
    out_event
  end

  private def map_mouse(i : ::NCurses::MouseEvent) : TUI::Event::Mouse
    outp = TUI::Event::Mouse.new({i.coordinates[:x], i.coordinates[:y]})
    outp.mouse = TUI::MouseStatus::None
    i.state.each do |s|
      new_state = convert_mouse_state(s)
      outp.mouse = outp.mouse | new_state
    end
    outp
  end

  private def convert_mouse_state(i : ::NCurses::Mouse) : TUI::MouseStatus
    case i
    when ::NCurses::Mouse::B1Released then TUI::MouseStatus::PrimaryRelease
    when ::NCurses::Mouse::B1Pressed  then TUI::MouseStatus::PrimaryPress
    when ::NCurses::Mouse::B1Clicked  then TUI::MouseStatus::PrimaryClick
    when ::NCurses::Mouse::B1DoubleClicked then TUI::MouseStatus::PrimaryDoubleClick
    when ::NCurses::Mouse::B1TripleClicked then TUI::MouseStatus::PrimaryTripleClick

    when ::NCurses::Mouse::B2Released then TUI::MouseStatus::MiddleRelease
    when ::NCurses::Mouse::B2Pressed then TUI::MouseStatus::MiddlePress
    when ::NCurses::Mouse::B2Clicked then TUI::MouseStatus::MiddleClick
    when ::NCurses::Mouse::B2DoubleClicked then TUI::MouseStatus::MiddleDoubleClick
    when ::NCurses::Mouse::B2TripleClicked then TUI::MouseStatus::MiddleTripleClick

    when ::NCurses::Mouse::B3Released then TUI::MouseStatus::SecondaryRelease
    when ::NCurses::Mouse::B3Pressed then TUI::MouseStatus::SecondaryPress
    when ::NCurses::Mouse::B3Clicked then TUI::MouseStatus::SecondaryClick
    when ::NCurses::Mouse::B3DoubleClicked then TUI::MouseStatus::SecondaryDoubleClick
    when ::NCurses::Mouse::B3TripleClicked then TUI::MouseStatus::SecondaryTripleClick

    when ::NCurses::Mouse::B4Pressed then TUI::MouseStatus::ScrollUp
    when ::NCurses::Mouse::B5Pressed then TUI::MouseStatus::ScrollDown
    else TUI::MouseStatus::None
    end
  end
end
