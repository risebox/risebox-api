class Risebox::Core::MetricStatusSerializer < ActiveModel::Serializer
  root false

  attributes :description, :level, :light, :limit_max, :limit_min, :metric_code, :value, :taken_at

  def metric_code
    object.metric.code
  end

end