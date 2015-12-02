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
                              {key: 'all_white_duration', data_type: 'integer', value: 600},
                              {key: 'ph_offset',       data_type: 'float',    value: 0}
                          ]
                  }

  @@metrics_ref = {hapy_2: [ { code: 'PH',    data: {limit_min: 6.2,    limit_max: 7.8,  meaning_min: 3,  meaning_max: 10}},
                              {code: 'WTEMP', data: {limit_min: 18,     limit_max: 25,   meaning_min: 5,  meaning_max: 50}},
                              {code: 'WVOL',  data: {limit_min: 100,    limit_max: 200,  meaning_min: 20, meaning_max: 250}},
                              {code: 'ATEMP', data: {limit_min: 18,     limit_max: 28,   meaning_min: 5,  meaning_max: 50}},
                              {code: 'AHUM',  data: {limit_min: 25,     limit_max: 60,   meaning_min: 10,  meaning_max: 100}},
                              {code: 'UCYC',  data: {limit_min: 300,    limit_max: 3000, meaning_min: 100,  meaning_max: nil}},
                              {code: 'LCYC',  data: {limit_min: 200,    limit_max: 2000, meaning_min: 100,  meaning_max: nil}},
                              {code: 'NO2',   data: {limit_min: 0,      limit_max: 1,    meaning_min: nil,  meaning_max: nil}},
                              {code: 'NH4',   data: {limit_min: 0,      limit_max: 0.5,  meaning_min: nil,  meaning_max: nil}},
                              {code: 'NO3',   data: {limit_min: 60,     limit_max: 500,  meaning_min: nil,  meaning_max: nil}},
                              {code: 'GH',    data: {limit_min: 4,      limit_max: 16,   meaning_min: nil,  meaning_max: nil}},
                              {code: 'KH',    data: {limit_min: 3,      limit_max: 10,   meaning_min: nil,  meaning_max: nil}}
                          ]
                  }

  after_create  :generate_settings, :generate_metric_statuses, :create_brain_user

  has_many   :raw_measures, class_name: 'Risebox::Core::Measure',          dependent: :destroy
  has_many   :meaningful_measures,  -> { where(meaningful: true) }, class_name: 'Risebox::Core::Measure'
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
    return if (set = @@settings_ref[model_key]).nil?
    set.each do |setting|
      unless self.settings.where(key: setting[:key]).exists?
        self.settings.create(setting.merge(changed_at: Time.now))
      end
    end
  end

  def generate_metric_statuses
    return if (set = @@metrics_ref[model_key]).nil?
    set.each do |metric_ref|
      metric        = Risebox::Core::Metric.find_by_code metric_ref[:code]
      unless Risebox::Core::MetricStatus.where(metric_id: metric.id, device_id: self.id).exists?
        Risebox::Core::MetricStatus.create(metric_ref[:data].merge({metric_id: metric.id, device_id: self.id}))
      end
    end
  end

  def reset_metric_statuses
    return if (set = @@metrics_ref[model_key]).nil?
    set.each do |metric_ref|
      metric        = Risebox::Core::Metric.find_by_code metric_ref[:code]
      metric_status = Risebox::Core::MetricStatus.where(metric_id: metric.id, device_id: self.id).first_or_create
      metric_status.update_attributes(metric_ref[:data])
    end
  end

  def create_brain_user
    user = Risebox::Core::User.create! email: "brain.#{self.key}@risebox.co", first_name: "brain", last_name: self.key, human: false
    Risebox::Core::DevicePermission.create! user: user, device: self
  end

  def brain
    @brain ||= self.users.where(human: false).first
  end

  def model_key
    :"#{self.model.downcase}_#{self.version}"
  end

  def owners_name
    owners.map(&:pretty_name)
  end
end