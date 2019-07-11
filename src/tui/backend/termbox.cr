require "lib_termbox"

class TUI::Backend::Termbox < TUI::Backend
  def start : self
    case LibTermbox.init
    when -1 then raise "Termbox error: unsupported terminal"
    when -2 then raise "Termbox error: failed to open TTY"
    when -3 then raise "Termbox error: pipe trap error"
    end
    LibTermbox.select_input_mode(LibTermbox::InputMode::Mouse)
    self
  end

  def stop : self
    LibTermbox.shutdown
    self
  end

  def width : Int32
    LibTermbox.width
  end

  def height : Int32
    LibTermbox.height
  end

  def draw(cell : TUI::Cell, x : Int32, y : Int32) : self
    LibTermbox.change_cell(x, y, cell.char.ord.to_u32, 0_u16, 0_u16)
    self
  end

  def refresh : self
    LibTermbox.present
    self
  end

  def clear : self
    LibTermbox.clear
    self
  end

  def poll(timeout : Int32 | Bool = false) : TUI::Event?
    event = uninitialized LibTermbox::Event
    type = case timeout
    when Int32 then LibTermbox.peek_event(pointerof(event), timeout)
    else # Bool
      if timeout
        LibTermbox.poll_event(pointerof(event))
      else
        LibTermbox.peek_event(pointerof(event), 0)
      end
    end
    return nil if type < 1
    case LibTermbox::EventType.new(event.type)
    when LibTermbox::EventType::Key then
      map_key(event.key)
    when LibTermbox::EventType::Resize then
      TUI::Event::Resize.new({event.w, event.h})
    when LibTermbox::EventType::Mouse then
      mse = TUI::Event::Mouse.new
      return nil unless btn = mouse_map(event.key)
      TUI::Event::Mouse.new(btn, {event.x, event.y})
    else return nil
    end
  end

  private def map_key(key) : TUI::Event::Key?
    out_event = TUI::Event::Key.new
    out_event.key = case LibTermbox::Key.from_value?(key)
    when LibTermbox::Key::ArrowUp    then TUI::Key::Up
    when LibTermbox::Key::ArrowDown  then TUI::Key::Down
    when LibTermbox::Key::ArrowLeft  then TUI::Key::Left
    when LibTermbox::Key::ArrowRight then TUI::Key::Right
    when nil then key.chr
    else
      STDERR.puts "Unhandled Termbox key #{key}"
      return nil
    end
    out_event
  end

  private def mouse_map(i : UInt16) : TUI::MouseStatus?
    case i
    when 0xFFFF_u16-22 then TUI::MouseStatus::PrimaryClick
    when 0xFFFF_u16-23 then TUI::MouseStatus::SecondaryClick
    when 0xFFFF_u16-24 then TUI::MouseStatus::MiddleClick
    when 0xFFFF_u16-26 then TUI::MouseStatus::ScrollUp
    when 0xFFFF_u16-27 then TUI::MouseStatus::ScrollDown
    else nil
    end
  end
end
