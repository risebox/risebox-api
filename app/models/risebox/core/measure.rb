class Risebox::Core::Measure < ActiveRecord::Base
  before_save :set_meaningful

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

private
  def set_meaningful
    if self.value_changed?
      self.meaningful = self.value.between? self.metric_status.meaning_min, self.metric_status.meaning_max
    end
  end
end