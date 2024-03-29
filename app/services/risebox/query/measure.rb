class Risebox::Query::Measure
  attr_reader :device

  def initialize device
    @device = device
  end

  def list metric, since
    [true, device.meaningful_measures.for_metric(metric).only_data.chronologic.since(since)]
  end

  def average_since metric, since
    device.meaningful_measures.for_metric(metric).since(since).average(:value)
  end

  def build_new metric_code, value, origin, taken_at
    metric = Risebox::Core::Metric.find_by_code metric_code
    device.raw_measures.new(metric: metric, value: value, origin: origin, taken_at: taken_at)
  end

  def create metric_code, value, origin='probe', taken_at=Time.now
    return [false, {error: :params, message: 'A value of nil is impossible for a measure'}] if value.nil?
    measure              = build_new(metric_code, value, origin, taken_at)
    measure_saved        = measure.save
    if measure_saved && measure.meaningful
      status_saved, status = Risebox::Query::MetricStatus.new(device).update(metric_code, value)
    end
    [measure_saved, measure]
  end

  def create_multiple_from_strip strip
    strip.metrics.each do |metric|
      create metric.to_s.upcase, strip.send(metric), 'strip', strip.tested_at
    end
  end

end