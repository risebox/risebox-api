class Risebox::Core::Measure < ActiveRecord::Base
  before_save :set_meaningful_if_value_changed

  belongs_to :device, class_name: 'Risebox::Core::Device'
  belongs_to :metric, class_name: 'Risebox::Core::Metric'

  scope :for_device, -> (device)   { where(device_id: device) }
  scope :for_metric, -> (metric)   { joins(:metric).where("metrics.code = ?", metric) }
  scope :since,      -> (datetime) { where('taken_at >= ?', datetime) }
  scope :recent,     ->            { order(taken_at: :desc) }
  scope :chronologic, ->           { order(taken_at: :asc) }
  scope :only_data,  ->            { select(:taken_at, :value) }

  def metric_status
  	@metric_status ||= Risebox::Core::MetricStatus.for_device(self.device_id).for_metric(self.metric_id).first
  end

  def set_meaningful
    m = true
    m = false if self.metric_status.meaning_min.present? && self.value < self.metric_status.meaning_min
    m = false if self.metric_status.meaning_max.present? && self.value > self.metric_status.meaning_max
    self.meaningful = m
  end

  def set_meaningful_if_value_changed
    if self.value_changed?
      set_meaningful
    end
    return true
  end
  
end