class Risebox::Core::DeviceSetting < ActiveRecord::Base
  before_save :update_changed_at

	belongs_to :device, class_name: 'Risebox::Core::Device', foreign_key: :device_id

  def value
    val = self.read_attribute(:value)
    return nil unless val.present?
    case self.data_type
      when 'string'
        val.to_s
      when 'integer'
        val.to_i
      when 'datetime'
        Time.at(val).to_datetime
      else
        val
    end
  end

  def value= val
    self.send('write_attribute', 'value', val.to_f)
  end

private

  def update_changed_at
    self.changed_at = Time.now
  end

end
