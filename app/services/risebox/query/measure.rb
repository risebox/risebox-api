class Risebox::Query::Measure
  attr_reader :device

  def initialize device
    @device = device
  end

  def list metric
    Risebox::Core::Measure.for_device(device).for_metric(metric).recent
  end

  def create metric, value
    measure = device.measures.new(metric: metric, value: value, taken_at: Time.now)
    [measure.save, measure]
  end

end