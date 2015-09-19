class Risebox::Core::LogEntry < ActiveRecord::Base
  belongs_to :device, class_name: 'Risebox::Core::Device', foreign_key: :device_id

  scope :recent, -> { order(logged_at: :desc) }

  def self.levels
    %w(info warning error)
  end

  def level= value
    if value.is_a?(String)
      hash = Hash[self.class.levels.map.with_index.to_a]
      self.send('write_attribute', 'level', hash[value])
    else
      self.send('write_attribute', 'level', value)
    end
  end

  def level_text
    level.nil? ? nil : self.class.levels[level]
  end
end