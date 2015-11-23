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
                              {key: 'fan_duty_ratio',  data_type: 'float',    value: 0.2 },
                              {key: 'brain_version',   data_type: 'float',    value: 0.1 },
                              {key: 'brain_update',    data_type: 'boolean',  value: 0   },
                              {key: 'all_white_duration'}, data_type: 'integer', value: 600}
                          ]
                  }


  after_create  :generate_settings, :create_brain_user

  has_many   :measures,         class_name: 'Risebox::Core::Measure',          dependent: :destroy
  has_many   :metric_statuses,  class_name: 'Risebox::Core::MetricStatus',     dependent: :destroy
  has_many   :strips,           class_name: 'Risebox::Core::Strip',            dependent: :destroy
  has_many   :settings,         class_name: 'Risebox::Core::DeviceSetting',    dependent: :destroy
  has_many   :logs,             class_name: 'Risebox::Core::LogEntry',         dependent: :destroy
  has_many   :user_permissions, class_name: 'Risebox::Core::DevicePermission', dependent: :destroy
  has_many   :owners,  -> { where(human: true) } , class_name: 'Risebox::Core::User', through:   :user_permissions, source: :user
  has_many :users, class_name: 'Risebox::Core::User', through:   :user_permissions, source: :user

  #belongs_to :owner, class_name: 'Risebox::Core::User', foreign_key: :owner_id

  #scope :for_credentials,  -> (key,secret) {where(key: key, token: secret)}

  def generate_settings
    return if (set = @@settings_ref[setting_key]).nil?
    set.each do |setting|
      unless self.settings.where(key: setting[:key]).exists?
        self.settings.create(setting.merge(changed_at: Time.now))
      end
    end
  end

  def create_brain_user
    user = Risebox::Core::User.create! email: "brain.#{self.key}@risebox.co", first_name: "brain", last_name: self.key, human: false
    Risebox::Core::DevicePermission.create! user: user, device: self
  end

  def brain
    @brain ||= self.users.where(human: false).first
  end

  def setting_key
    :"#{self.model.downcase}_#{self.version}"
  end

  def owners_name
    owners.map(&:pretty_name)
  end
end