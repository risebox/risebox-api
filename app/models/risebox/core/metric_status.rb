class Risebox::Core::MetricStatus < ActiveRecord::Base
  before_save :compute_level_and_light
  after_save  :manage_alerts

  belongs_to :device, class_name: 'Risebox::Core::Device'
  belongs_to :metric, class_name: 'Risebox::Core::Metric'


  scope :for_device,  -> (device_id) { where(device_id: device_id) }
  scope :with_metric, -> { joins(:metric).includes(:metric).order('metrics.display_order') }
  scope :for_metric,  -> (metric_id) { where(metric_id: metric_id) }

private

  def compute_level_and_light
    # return unless value_changed?

    if value.nil?
      future_level = 'none'
    elsif limit_min && value < limit_min
      future_level = 'low'
    elsif limit_max && value > limit_max
      future_level = 'high'
    else
      future_level = 'ok'
    end

    if future_level == 'ok'
      future_light = 'green'
    elsif future_level == 'none'
      future_light = 'grey'
    else
      future_light = 'red'
    end

    if future_light == 'red' && light != 'red'
      @begin_alert = true
    end
    if future_light == 'green' && light == 'red'
      @end_alert = true
    end

    self.level = future_level
    self.light = future_light
  end

  def manage_alerts
    if @begin_alert
      self.device.owners.each do |owner|
        JobRunner.run(SendEmail, 'device_alert', 'Risebox::Core::MetricStatus', self.id, 'recipient_email' => owner.email )
      end
    end
    # TODO: Mémoriser la durée de l'alerte
  end
end