class Risebox::Core::MetricStatusSerializer < ActiveModel::Serializer
  root false

  attributes :description, :level, :light, :limit_max, :limit_min, :code, :value, :taken_at

  def code
    object.metric.code
  end

  def value
    if object.value.present?
      object.metric.unit.present? ? "#{object.value} #{object.metric.unit}" : object.value.to_s
    else
      nil
    end
    "#{object.value} #{object.metric.unit}"
  end

end