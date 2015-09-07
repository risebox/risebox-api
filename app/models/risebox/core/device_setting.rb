class Risebox::Core::DeviceSetting < ActiveRecord::Base
	belongs_to :device, class_name: 'Risebox::Core::Device', foreign_key: :device_id

  def value
    val = self.read_attribute(:value)
    return nil unless val.present?
    return val.is_a?(String)
    case self.data_type
      when 'integer'
        val.to_i
      when 'float'
        val.to_f
      when 'datetime'
        DateTime.new(val)
      else
        val
    end
  end

  def value= val
    self.send('write_attribute', 'value', val.to_s)
  end
end
