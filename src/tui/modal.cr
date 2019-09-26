require "./window"

abstract class TUI::Modal < TUI::Window
  include EventLoop

  def initialize(app)
    @app = app
    super(self, app.@backend, fps: app.fps, painter: app.@painter)
  end

  def self.exec(app)
    self.new(app).exec
  end
end
