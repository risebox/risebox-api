class Risebox::Core::MetricStatus < ActiveRecord::Base
  belongs_to :device, class_name: 'Risebox::Core::Device'
  belongs_to :metric, class_name: 'Risebox::Core::Metric'

  scope :for_device,  -> (device) { where(device_id: device) }
  scope :with_metric, -> (metric) { includes(:metric)        }
end