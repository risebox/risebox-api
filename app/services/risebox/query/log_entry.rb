class Risebox::Query::LogEntry
  attr_reader :device

  def initialize device
    @device = device
  end

  def list
    [true, device.logs.recent]
  end

  def build_new level, body, logged_at
    device.logs.new(level: level, body: body, logged_at: logged_at)
  end

  def create level, body, logged_at
    log_entry = build_new(level, body, logged_at)
    [log_entry.save, log_entry]
  end

end