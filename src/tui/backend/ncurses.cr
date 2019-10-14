require "ncurses"

class TUI::Backend::NCurses < TUI::Backend
  ERR = -1
  OK = 0

  def start : self
    raise "TUI Backend already active" if @started
    ::NCurses.start
    ::NCurses.no_echo
    ::NCurses.set_cursor ::NCurses::Cursor::Invisible
    ::NCurses.keypad true
    ::NCurses.mouse_mask(::NCurses::Mouse::AllEvents | ::NCurses::Mouse::Position)
    @started = true
    self
  end

  def stop : self
    raise "TUI Backend not active" unless @started
    ::NCurses.end
    @started = false
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

  def refresh : self
    ::NCurses.refresh
    self
  end

  def clear : self
    ::NCurses.clear
    self
  end

  def poll(timeout : Int32 | Bool = false) : TUI::Event?
    case timeout
    when false then ::NCurses.stdscr.timeout = 0
    when true  then ::NCurses.no_timeout
    when Int32 then ::NCurses.stdscr.timeout = timeout
    end
    return nil unless event = ::NCurses.get_char
    case event
    when ::NCurses::Key::Mouse then
      return nil if (LibNCurses.getmouse(out mouse)) == ERR
      return map_mouse(::NCurses::MouseEvent.new(mouse))
    when ::NCurses::Key::Resize then
      TUI::Event::Resize.new({width, height})
    else
      return map_key(event)
    end
  end

  private def map_key(event : ::NCurses::Key | Char) : TUI::Event::Key?
    out_event = TUI::Event::Key.new
    out_event.key = case event
    when Char then event
    when ::NCurses::Key::Up        then TUI::Key::Up
    when ::NCurses::Key::Down      then TUI::Key::Down
    when ::NCurses::Key::Left      then TUI::Key::Left
    when ::NCurses::Key::Right     then TUI::Key::Right
    when ::NCurses::Key::Home      then TUI::Key::Home
    when ::NCurses::Key::End       then TUI::Key::End
    when ::NCurses::Key::PageUp    then TUI::Key::PageUp
    when ::NCurses::Key::PageDown  then TUI::Key::PageDown
    when ::NCurses::Key::Insert    then TUI::Key::Insert
    when ::NCurses::Key::Delete    then TUI::Key::Delete
    when ::NCurses::Key::Backspace then TUI::Key::Backspace
    when ::NCurses::Key::Enter     then TUI::Key::Enter
    when ::NCurses::Key::F1        then TUI::Key::F1
    when ::NCurses::Key::F2        then TUI::Key::F2
    when ::NCurses::Key::F3        then TUI::Key::F3
    when ::NCurses::Key::F4        then TUI::Key::F4
    when ::NCurses::Key::F5        then TUI::Key::F5
    when ::NCurses::Key::F6        then TUI::Key::F6
    when ::NCurses::Key::F7        then TUI::Key::F7
    when ::NCurses::Key::F8        then TUI::Key::F8
    when ::NCurses::Key::F9        then TUI::Key::F9
    when ::NCurses::Key::F10       then TUI::Key::F10
    when ::NCurses::Key::F11       then TUI::Key::F11
    when ::NCurses::Key::F12       then TUI::Key::F12
    when ::NCurses::Key::Esc       then TUI::Key::Escape
    when ::NCurses::Key::ShiftLeft
      out_event.shift = true
      TUI::Key::Left
    when ::NCurses::Key::ShiftRight
      out_event.shift = true
      TUI::Key::Right
    when ::NCurses::Key::ShiftUp
      out_event.shift = true
      TUI::Key::Up
    when ::NCurses::Key::ShiftDown
      out_event.shift = true
      TUI::Key::Down
    when ::NCurses::Key::ShiftTab
      out_event.shift = true
      '\t'
    when ::NCurses::Key::ShiftDelete
      out_event.shift = true
      TUI::Key::Delete
    when ::NCurses::Key::ShiftEnd
      out_event.shift = true
      TUI::Key::End
    when ::NCurses::Key::ShiftHome
      out_event.shift = true
      TUI::Key::Home
    when ::NCurses::Key::ShiftPageDown
      out_event.shift = true
      TUI::Key::PageDown
    when ::NCurses::Key::ShiftPageUp
      out_event.shift = true
      TUI::Key::PageUp
    else
      TUI.logger.error "Unhandled key: #{event}"
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
