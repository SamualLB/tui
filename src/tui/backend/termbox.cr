require "lib_termbox"

class TUI::Backend::Termbox < TUI::Backend
  def start : self
    raise "TUI Backend already active" if @started
    create_input_channel
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

  private def parse_event(ev : LibTermbox::Event) : TUI::Event?
    case LibTermbox::EventType.new(ev.type)
    when LibTermbox::EventType::Key then
      map_key(ev.key, ev.ch, ev.mod)
    when LibTermbox::EventType::Resize then
      TUI::Event::Resize.new({ev.w, ev.h})
    when LibTermbox::EventType::Mouse then
      mse = TUI::Event::Mouse.new
      return nil unless btn = map_mouse(ev.key)
      TUI::Event::Mouse.new(btn, {ev.x, ev.y})
    else raise "Unknown Termbox event #{ev.type}"
    end
  end

  private def create_input_channel
    @channel = Channel(TUI::Event).new if @channel.closed?
    spawn do
      until @started
        Fiber.yield
      end
      until @channel.closed?
        event_type = LibTermbox.poll_event(out event)
        next if event_type <= 0 # Ignore error events
        parsed = parse_event(event)
        next unless parsed # Ignore invalid event attributes
        @channel.send(parsed)
        Fiber.yield # Prevents buffering when running on a single thread
      end
    end
  end

  private def map_key(key, ch, mod) : TUI::Event::Key?
    TUI.logger.error "Termbox modifier: #{mod}" unless mod == 0
    return TUI::Event::Key.new(ch.chr) unless ch == 0

    out_key = map_key_key(LibTermbox::Key.from_value?(key))
    if out_key.nil?
      TUI.logger.info "Unhandled Termbox key #{key} #{LibTermbox::Key.from_value?(key)}, #{ch}"
      return nil
    end
    out_mod = map_key_mod(LibTermbox::Key.from_value?(key))
    case out_mod
    when nil    then TUI::Event::Key.new(out_key)
    when :alt   then TUI::Event::Key.new(out_key, alt: true)
    when :ctrl  then TUI::Event::Key.new(out_key, ctrl: true)
    when :shift then TUI::Event::Key.new(out_key, shift: true)
    else raise "Unknown mod state"
    end
  end

  private def map_key_key(k : LibTermbox::Key?) : TUI::Key | Char | Nil
    case k
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
    when LibTermbox::Key::CtrlA      then 'a'
    when LibTermbox::Key::CtrlB      then 'b'
    when LibTermbox::Key::CtrlC      then 'c'
    when LibTermbox::Key::CtrlD      then 'd'
    when LibTermbox::Key::CtrlE      then 'e'
    when LibTermbox::Key::CtrlF      then 'f'
    when LibTermbox::Key::CtrlG      then 'g'
    when LibTermbox::Key::CtrlH      then 'h'
    when LibTermbox::Key::CtrlI      then 'i'
    when LibTermbox::Key::CtrlJ      then 'j'
    when LibTermbox::Key::CtrlK      then 'k'
    when LibTermbox::Key::CtrlL      then 'l'
    when LibTermbox::Key::CtrlM      then 'm'
    when LibTermbox::Key::CtrlN      then 'n'
    when LibTermbox::Key::CtrlO      then 'o'
    when LibTermbox::Key::CtrlP      then 'p'
    when LibTermbox::Key::CtrlQ      then 'q'
    when LibTermbox::Key::CtrlR      then 'r'
    when LibTermbox::Key::CtrlS      then 's'
    when LibTermbox::Key::CtrlT      then 't'
    when LibTermbox::Key::CtrlU      then 'u'
    when LibTermbox::Key::CtrlV      then 'v'
    when LibTermbox::Key::CtrlW      then 'w'
    when LibTermbox::Key::CtrlX      then 'x'
    when LibTermbox::Key::CtrlY      then 'y'
    when LibTermbox::Key::CtrlZ      then 'z'
    when LibTermbox::Key::Ctrl3      then '3'
    when LibTermbox::Key::Ctrl4      then '4'
    when LibTermbox::Key::Ctrl5      then '5'
    when LibTermbox::Key::Ctrl6      then '6'
    when LibTermbox::Key::Ctrl7      then '7'
    when LibTermbox::Key::Ctrl8      then '8'
    when LibTermbox::Key::CtrlTilde  then '`'
    when LibTermbox::Key::CtrlLeftSquareBracket then '['
    when LibTermbox::Key::CtrlRightSquareBracket then ']'
    when LibTermbox::Key::CtrlBackslash then '\\'
    when LibTermbox::Key::CtrlSlash then '/'
    when LibTermbox::Key::CtrlUnderscore then '_'
    else nil
    end
  end

  private def map_key_mod(k : LibTermbox::Key?) : Symbol?
    case k
    when LibTermbox::Key::ArrowUp    then nil
    when LibTermbox::Key::ArrowDown  then nil
    when LibTermbox::Key::ArrowLeft  then nil
    when LibTermbox::Key::ArrowRight then nil
    when LibTermbox::Key::Home       then nil
    when LibTermbox::Key::End        then nil
    when LibTermbox::Key::PageUp     then nil
    when LibTermbox::Key::PageDown   then nil
    when LibTermbox::Key::Insert     then nil
    when LibTermbox::Key::Delete     then nil
    when LibTermbox::Key::Backspace,
         LibTermbox::Key::Backspace2 then nil
    when LibTermbox::Key::Enter      then nil
    when LibTermbox::Key::Space      then nil
    when LibTermbox::Key::Tab        then nil
    when LibTermbox::Key::F1         then nil
    when LibTermbox::Key::F2         then nil
    when LibTermbox::Key::F3         then nil
    when LibTermbox::Key::F4         then nil
    when LibTermbox::Key::F5         then nil
    when LibTermbox::Key::F6         then nil
    when LibTermbox::Key::F7         then nil
    when LibTermbox::Key::F8         then nil
    when LibTermbox::Key::F9         then nil
    when LibTermbox::Key::F10        then nil
    when LibTermbox::Key::F11        then nil
    when LibTermbox::Key::F12        then nil
    when LibTermbox::Key::Escape     then nil
    when LibTermbox::Key::CtrlA      then :ctrl
    when LibTermbox::Key::CtrlB      then :ctrl
    when LibTermbox::Key::CtrlC      then :ctrl
    when LibTermbox::Key::CtrlD      then :ctrl
    when LibTermbox::Key::CtrlE      then :ctrl
    when LibTermbox::Key::CtrlF      then :ctrl
    when LibTermbox::Key::CtrlG      then :ctrl
    when LibTermbox::Key::CtrlH      then :ctrl
    when LibTermbox::Key::CtrlI      then :ctrl
    when LibTermbox::Key::CtrlJ      then :ctrl
    when LibTermbox::Key::CtrlK      then :ctrl
    when LibTermbox::Key::CtrlL      then :ctrl
    when LibTermbox::Key::CtrlM      then :ctrl
    when LibTermbox::Key::CtrlN      then :ctrl
    when LibTermbox::Key::CtrlO      then :ctrl
    when LibTermbox::Key::CtrlP      then :ctrl
    when LibTermbox::Key::CtrlQ      then :ctrl
    when LibTermbox::Key::CtrlR      then :ctrl
    when LibTermbox::Key::CtrlS      then :ctrl
    when LibTermbox::Key::CtrlT      then :ctrl
    when LibTermbox::Key::CtrlU      then :ctrl
    when LibTermbox::Key::CtrlV      then :ctrl
    when LibTermbox::Key::CtrlW      then :ctrl
    when LibTermbox::Key::CtrlX      then :ctrl
    when LibTermbox::Key::CtrlY      then :ctrl
    when LibTermbox::Key::CtrlZ      then :ctrl
    when LibTermbox::Key::Ctrl3      then :ctrl
    when LibTermbox::Key::Ctrl4      then :ctrl
    when LibTermbox::Key::Ctrl5      then :ctrl
    when LibTermbox::Key::Ctrl6      then :ctrl
    when LibTermbox::Key::Ctrl7      then :ctrl
    when LibTermbox::Key::Ctrl8      then :ctrl
    when LibTermbox::Key::CtrlTilde  then :ctrl
    when LibTermbox::Key::CtrlLeftSquareBracket then :ctrl
    when LibTermbox::Key::CtrlRightSquareBracket then :ctrl
    when LibTermbox::Key::CtrlBackslash then :ctrl
    when LibTermbox::Key::CtrlSlash then :ctrl
    when LibTermbox::Key::CtrlUnderscore then :ctrl
    else nil
    end
  end


  @mouse_press : TUI::MouseStatus?

  private def map_mouse(i : UInt16) : TUI::MouseStatus?
    out = case LibTermbox::Key.new(i)
    when LibTermbox::Key::MouseLeft      then TUI::MouseStatus::PrimaryClick
    when LibTermbox::Key::MouseRight     then TUI::MouseStatus::SecondaryClick
    when LibTermbox::Key::MouseMiddle    then TUI::MouseStatus::MiddleClick
    when LibTermbox::Key::MouseWheelUp   then TUI::MouseStatus::ScrollUp
    when LibTermbox::Key::MouseWheelDown then TUI::MouseStatus::ScrollDown
    # ignore release, only provide unique clicks
    when LibTermbox::Key::MouseRelease
      @mouse_press = nil
      return nil
    else
      TUI.logger.info "Unhandled Termbox mouse: #{i}, #{LibTermbox::Key.new(i)}"
        nil
    end
    @mouse_press ? nil : (@mouse_press = out)
  end
end
