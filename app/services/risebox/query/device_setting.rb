class Risebox::Query::DeviceSetting
  attr_reader :device

  def initialize device, brain_calling=false
    @device = device
    @brain_calling = brain_calling
  end

  def delta_list
    now = Time.now
    result  = device.settings.where("changed_at >= ?", device.settings_queried_at)
    @brain_calling ? update_queried_at_and_return(now, result) : [true, result]
  end

  def full_list
    now = Time.now
    result  = device.settings
    @brain_calling ? update_queried_at_and_return(now, result) : [true, result]
  end

  def select_list selection
    now = Time.now
    result = device.settings.where(key: selection)
    @brain_calling ? update_queried_at_and_return(now, result) : [true, result]
  end

  def bulk_update settings
    puts "settings #{settings}"
    errors = {}
    success = []
    settings.each do |k, v|
      setting = device.settings.where(key: k).first
      unless setting.update_attributes(value: v)
        errors[k] = setting.errors
      end
    end
    errors.empty? ? [true, settings] : [false, {error: :bulk_update_failed, message: "#{errors.size()} errors : settings #{errors.keys} were not updated"}]
  end

private

	def update_queried_at_and_return now, result
		updated = @device.update_attribute(:settings_queried_at, now)
    updated ? [true, result] : [false, {error: :data_update_failed, message: 'Could not update device settings query date'}]
	end

end
