class Risebox::Query::MetricStatus
  attr_reader :device

  def initialize device
    @device = device
  end

  def list
    [true, Risebox::Core::MetricStatus.for_device(device).with_metric(metric)]
  end

  def update metric_code, value
    metric        = Risebox::Core::Metric.find_by_code metric_code
    metric_status = Risebox::Core::MetricStatus.where(metric_id: metric.id, device_id: device.id).first_or_create
    [metric_status.update_attributes(value: value, taken_at: Time.now), metric_status]
  end

end