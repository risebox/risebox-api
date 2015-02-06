class Risebox::Core::Measure < ActiveRecord::Base
  belongs_to :device, class_name: 'Risebox::Core::Device'

  scope :for_device, -> (device) { where(device_id: device) }
  scope :for_metric, -> (metric) { where(metric: metric) }
  scope :recent,     ->          { order(taken_at: :desc) }
end