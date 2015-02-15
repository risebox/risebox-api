class Risebox::Query::Measure
  attr_reader :device

  def initialize device
    @device = device
  end

  def list metric
    [true, Risebox::Core::Measure.for_device(device).for_metric(metric).recent]
  end

  def build_new metric, value
    device.measures.new(metric: metric, value: value, taken_at: Time.now)
  end

  def create metric, value
    measure = build_new(metric, value)
    [measure.save, measure]
  end

end