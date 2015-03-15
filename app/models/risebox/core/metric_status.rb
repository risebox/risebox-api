class Risebox::Core::MetricStatus < ActiveRecord::Base
  belongs_to :device, class_name: 'Risebox::Core::Device'
  belongs_to :metric, class_name: 'Risebox::Core::Metric'

  scope :for_device,  -> (device) { where(device_id: device) }
  scope :with_metric, -> { joins(:metric).includes(:metric).order('metrics.display_order') }

  def level
    return 'N/A' if value.nil?
    if limit_min && value < limit_min
      level = 'Trop bas'
    elsif limit_max && value > limit_max
      level = 'Trop haut'
    else
      level = 'OK'
    end
    level
  end

  def light
    l = level
    return 'green' if l == 'OK'
    return 'grey'  if l == 'N/A'
    return 'red'
  end
end