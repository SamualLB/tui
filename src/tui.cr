require "logger"
require "./tui/*"

module TUI
  VERSION = "0.0.1"

  @@logger_file : File = File.tempfile
  class_getter logger = Logger.new(@@logger_file)
  self.logger.info "Logger init"

  def self.dump_log
    @@logger_file.rewind.each_line do |l|
      STDERR.puts l
    end
    @@logger_file.delete
    logger.close
  end
end
