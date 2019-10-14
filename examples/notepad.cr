require "../src/tui"

class Notepad < TUI::Window
  def paint(painter : TUI::Painter)
    painter[0, 0] = "Notepad"
    true
  end

  def handle(event : TUI::Event::Key) : Bool
    layout.each_window do |child|
      return true if child.handle(event)
    end
    TUI.logger.info "Notepad pretended to handle key event: #{event}"
    true
  end

  def handle(event : TUI::Event::Mouse) : Bool
    TUI.logger.info "Notepad pretended to handle mouse event: #{event}"
    true
  end
end

class NotepadPopup < TUI::Modal
  def paint(painter : TUI::Painter)
    painter[0, 1] = "Popup"
    painter[50, 2] = "really long string that goes over multiple lines and isnfjds sdnjflnsn fdns nnsf kjdnfjksnkj nkjsnkj nfka noenfoiajnln g;ajrisj ijaios jgjfajgjhrnufnbgka bnan gbeu gfui biu bniafbnei niufnin diugn e ga euib iubneiugnbnbie eiuf gu eiuh ngaeui hghi huiguiaeniu niuae ei u;iea ffebh igbh ae;ifg ua beui f;ia bfuie auebi ieif fib iubuih uigi  iuae buinbuaieubg niubi"
    painter[50, 12, 10] = "really long string that goes over multiple lines and isnfjds sdnjflnsn fdns nnsf kjdnfjksnkj nkjsnkj nfka noenfoiajnln g;ajrisj ijaios jgjfajgjhrnufnbgka bnan gbeu gfui biu bniafbnei niufnin diugn e ga euib iubneiugnbnbie eiuf gu eiuh ngaeui hghi huiguiaeniu niuae ei u;iea ffebh igbh ae;ifg ua beui f;ia bfuie auebi ieif fib iubuih uigi  iuae buinbuaieubg niubi"
    painter[5, 0] = '!'
    true
  end
end

app = TUI::Application.new(Notepad, TUI::Backend::NCurses, fps: 2.5, title: "Notepad")

app.callback(2.5.seconds) do
  NotepadPopup.exec(app)
end

app.exec
