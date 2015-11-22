class Risebox::Core::Measure < ActiveRecord::Base
  belongs_to :device, class_name: 'Risebox::Core::Device'
  belongs_to :metric, class_name: 'Risebox::Core::Metric'

  scope :for_device, -> (device)   { where(device_id: device) }
  scope :for_metric, -> (metric)   { joins(:metric).where("metrics.code = ?", metric) }
  scope :since,      -> (datetime) { where('taken_at >= ?', datetime) }
  scope :recent,     ->            { order(taken_at: :desc) }
  scope :chronologic, ->           { order(taken_at: :asc) }
  scope :only_data,  ->            { select(:taken_at, :value) }
end