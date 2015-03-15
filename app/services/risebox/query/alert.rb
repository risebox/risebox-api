class Risebox::Query::Alert
  attr_reader :device

  def initialize device
    @device = device
  end

  def create metric_code, value, description
    status_saved, status = Risebox::Query::MetricStatus.new(device).update(metric_code, value, description)
    [status_saved, status]
  end

end