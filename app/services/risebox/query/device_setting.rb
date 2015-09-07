class Risebox::Query::DeviceSetting
  attr_reader :device

  def initialize device
    @device = device
  end

  def delta_list
  	now = Time.now
    result  = device.settings.where("changed_at >= ?", device.settings_queried_at)
    return update_queried_at_and_return now, result
  end

  def full_list
  	now = Time.now
    result  = device.settings
    return update_queried_at_and_return now, result
  end

private

	def update_queried_at_and_return now, result
		updated = @device.update_attribute(:settings_queried_at, now)
    updated ? [true, result] : [false, {error: :data_update_failed, message: 'Could not update device settings query date'}]
	end

end
