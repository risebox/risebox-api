class Risebox::Core::Device < ActiveRecord::Base

  @@settings_ref = {hapy_2: [ {key: 'upper_blue',      data_type: 'float',    value: 50  },
                              {key: 'upper_red',       data_type: 'float',    value: 50  },
                              {key: 'upper_white',     data_type: 'float',    value: 0   },
                              {key: 'lower_blue',      data_type: 'float',    value: 50  },
                              {key: 'lower_red',       data_type: 'float',    value: 50  },
                              {key: 'lower_white',     data_type: 'float',    value: 0   },
                              {key: 'all_white_until', data_type: 'datetime', value: nil },
                              {key: 'silent_until',    data_type: 'datetime', value: nil },
                              {key: 'no_lights_until', data_type: 'datetime', value: nil },
                              {key: 'day_hours',       data_type: 'integer',  value: 7   },
                              {key: 'day_minutes',     data_type: 'integer',  value: 0   },
                              {key: 'night_hours',     data_type: 'integer',  value: 21  },
                              {key: 'night_minutes',   data_type: 'integer',  value: 0   },
                              {key: 'fan_duty_ratio',  data_type: 'float',    value: 0.2 }
                          ]
                  }

  before_create :generate_token
  after_create  :generate_settings

  has_many   :measures,        class_name: 'Risebox::Core::Measure',       dependent: :destroy
  has_many   :metric_statuses, class_name: 'Risebox::Core::MetricStatus',  dependent: :destroy
  has_many   :strips,          class_name: 'Risebox::Core::Strip',         dependent: :destroy
  has_many   :settings,        class_name: 'Risebox::Core::DeviceSetting', dependent: :destroy
  has_many   :logs,            class_name: 'Risebox::Core::LogEntry',      dependent: :destroy

  belongs_to :owner, class_name: 'Risebox::Core::User', foreign_key: :owner_id

  scope :for_credentials,  -> (key,secret) {where(key: key, token: secret)}

  def generate_token
    begin
      self.token = SecureRandom.hex
    end while self.class.exists?(token: token)
    self.token
  end

  def generate_settings
    return if (set = @@settings_ref[setting_key]).nil?
    set.each do |setting|
      unless self.settings.where(key: setting[:key]).exists?
        self.settings.create(setting.merge(changed_at: Time.now))
      end
    end
  end

  def setting_key
    :"#{self.model.downcase}_#{self.version}"
  end
end