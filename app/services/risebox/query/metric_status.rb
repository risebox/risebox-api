class Risebox::Query::MetricStatus
  attr_reader :device

  def initialize device
    @device = device
  end

  def list
    [true, Risebox::Core::MetricStatus.for_device(device).with_metric]
  end

  def update metric_code, value, description=nil
    metric        = Risebox::Core::Metric.find_by_code metric_code
    metric_status = Risebox::Core::MetricStatus.where(metric_id: metric.id, device_id: device.id).first_or_create
    updated = metric_status.update_attributes(value: value, taken_at: Time.now, description: description)
    if updated
      JobRunner.run AgregateMeasuresOnMetricStatus, metric_status.id
    end
    [updated, metric_status]
  end

end