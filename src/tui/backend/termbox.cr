require "lib_termbox"

class TUI::Backend::Termbox < TUI::Backend
  def start : self
    raise "TUI Backend already active" if @started
    case LibTermbox.init
    when -1 then raise "Termbox error: unsupported terminal"
    when -2 then raise "Termbox error: failed to open TTY"
    when -3 then raise "Termbox error: pipe trap error"
    end
    LibTermbox.select_input_mode(LibTermbox::InputMode::Mouse)
    @started = true
    self
  end

  def stop : self
    raise "TUI Backend not active" unless @started
    LibTermbox.shutdown
    @started = false
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
      map_key(event.key, event.ch)
    when LibTermbox::EventType::Resize then
      TUI::Event::Resize.new({event.w, event.h})
    when LibTermbox::EventType::Mouse then
      mse = TUI::Event::Mouse.new
      return nil unless btn = map_mouse(event.key)
      TUI::Event::Mouse.new(btn, {event.x, event.y})
    else return nil
    end
  end

  private def map_key(key, ch) : TUI::Event::Key?
    out_event = TUI::Event::Key.new
    unless ch == 0
      out_event.key = ch.chr
      return out_event
    end
    out_event.key = case LibTermbox::Key.from_value?(key)
    when LibTermbox::Key::ArrowUp    then TUI::Key::Up
    when LibTermbox::Key::ArrowDown  then TUI::Key::Down
    when LibTermbox::Key::ArrowLeft  then TUI::Key::Left
    when LibTermbox::Key::ArrowRight then TUI::Key::Right
    when LibTermbox::Key::Home       then TUI::Key::Home
    when LibTermbox::Key::End        then TUI::Key::End
    when LibTermbox::Key::PageUp     then TUI::Key::PageUp
    when LibTermbox::Key::PageDown   then TUI::Key::PageDown
    when LibTermbox::Key::Insert     then TUI::Key::Insert
    when LibTermbox::Key::Delete     then TUI::Key::Delete
    when LibTermbox::Key::Backspace,
         LibTermbox::Key::Backspace2 then TUI::Key::Backspace
    when LibTermbox::Key::Enter      then TUI::Key::Enter
    when LibTermbox::Key::Space      then ' '
    when LibTermbox::Key::Tab        then '\t'
    when LibTermbox::Key::F1         then TUI::Key::F1
    when LibTermbox::Key::F2         then TUI::Key::F2
    when LibTermbox::Key::F3         then TUI::Key::F3
    when LibTermbox::Key::F4         then TUI::Key::F4
    when LibTermbox::Key::F5         then TUI::Key::F5
    when LibTermbox::Key::F6         then TUI::Key::F6
    when LibTermbox::Key::F7         then TUI::Key::F7
    when LibTermbox::Key::F8         then TUI::Key::F8
    when LibTermbox::Key::F9         then TUI::Key::F9
    when LibTermbox::Key::F10        then TUI::Key::F10
    when LibTermbox::Key::F11        then TUI::Key::F11
    when LibTermbox::Key::F12        then TUI::Key::F12
    when LibTermbox::Key::Escape     then TUI::Key::Escape
    when nil then
      STDERR.puts "Nil key #{key}: #{key.chr}"
      key.chr
    else
      STDERR.puts "Unhandled Termbox key #{LibTermbox::Key.from_value(key)}: #{key}"
      return nil
    end
    out_event
  end

  # Keep track of previous mouse status to see what button was released
  @previous_mouse : TUI::MouseStatus? = nil

  private def map_mouse(i : UInt16) : TUI::MouseStatus?
    TUI.logger.info "Mouse: #{i}"
    out = case LibTermbox::Key.new(i)
    when LibTermbox::Key::MouseLeft      then TUI::MouseStatus::PrimaryClick
    when LibTermbox::Key::MouseRight     then TUI::MouseStatus::SecondaryClick
    when LibTermbox::Key::MouseMiddle    then TUI::MouseStatus::MiddleClick
    when LibTermbox::Key::MouseWheelUp   then TUI::MouseStatus::ScrollUp
    when LibTermbox::Key::MouseWheelDown then TUI::MouseStatus::ScrollDown
    when LibTermbox::Key::MouseRelease
      case @previous_mouse
      when TUI::MouseStatus::PrimaryClick   then TUI::MouseStatus::PrimaryRelease
      when TUI::MouseStatus::SecondaryClick then TUI::MouseStatus::SecondaryRelease
      when TUI::MouseStatus::MiddleClick    then TUI::MouseStatus::MiddleRelease
      else
        STDERR.puts "Unrecognised Termbox previous mouse: #{@previous_mouse}"
        nil
      end
    else nil
    end
    TUI.logger.info "Mouse: #{out}"
    @previous_mouse = out
  end
end
