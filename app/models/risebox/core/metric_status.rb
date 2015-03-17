class Risebox::Core::MetricStatus < ActiveRecord::Base
  before_save :compute_level_and_light
  after_save  :manage_alerts

  belongs_to :device, class_name: 'Risebox::Core::Device'
  belongs_to :metric, class_name: 'Risebox::Core::Metric'


  scope :for_device,  -> (device) { where(device_id: device) }
  scope :with_metric, -> { joins(:metric).includes(:metric).order('metrics.display_order') }

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
    JobRunner.run(SendEmail, 'device_alert', 'Risebox::Core::MetricStatus', self.id) if @begin_alert
    # TODO: Mémoriser la durée de l'alerte
  end
end