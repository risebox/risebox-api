class Risebox::Query::Measure
  attr_reader :device

  def initialize device
    @device = device
  end

  def list metric
    [true, Risebox::Core::Measure.for_device(device).for_metric(metric).recent]
  end

  def build_new metric_code, value, origin, taken_at
    metric = Risebox::Core::Metric.find_by_code metric_code
    device.measures.new(metric: metric, value: value, origin: origin, taken_at: taken_at)
  end

  def create metric_code, value, origin='probe', taken_at=Time.now
    measure              = build_new(metric_code, value, origin, taken_at)
    measure_saved        = measure.save
    status_saved, status = Risebox::Query::MetricStatus.new(device).update(metric_code, value)
    [measure_saved && status_saved, measure]
  end

  def create_multiple_from_strip strip
    strip.metrics.each do |metric|
      create metric.to_s.upcase, strip.send(metric), 'strip', strip.tested_at
    end
  end

end