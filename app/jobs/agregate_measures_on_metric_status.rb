class AgregateMeasuresOnMetricStatus < JobBase
  acts_as_scalable

  @queue  = :agregate_measures

  def self.do_perform metric_status_id
    metric_status = Risebox::Core::MetricStatus.find(metric_status_id)
    device = metric_status.device
    metric_key = metric_status.metric.code
    measure_service = Risebox::Query::Measure.new(device)
    averages = {  hourly_average: nil,
                  daily_average:  nil,
                  weekly_average: nil,
                  monthly_average: nil }

    averages[:hourly_average] = measure_service.average_since(metric_key, 1.hour.ago)
    averages[:daily_average]  = measure_service.average_since(metric_key, 1.day.ago)
    averages[:weekly_average] = measure_service.average_since(metric_key, 1.week.ago)
    averages[:monthly_average] = measure_service.average_since(metric_key, 1.month.ago)
    puts "New agregate values for metric status #{metric_key} on device #{device.name} are : "
    puts averages

    metric_status.update_attributes(averages)
  end
end