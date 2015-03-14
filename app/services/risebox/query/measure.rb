class Risebox::Query::Measure
  attr_reader :device

  def initialize device
    @device = device
  end

  def list metric
    [true, Risebox::Core::Measure.for_device(device).for_metric(metric).recent]
  end

  def build_new metric_code, value
    metric = Risebox::Core::Metric.find_by_code metric_code
    device.measures.new(metric: metric, value: value, taken_at: Time.now)
  end

  def create metric_code, value
    measure              = build_new(metric_code, value)
    measure_saved        = measure.save
    status_saved, status = Risebox::Query::MetricStatus.new(device).update(metric_code, value)
    [measure_saved && status_saved, measure]
  end

end