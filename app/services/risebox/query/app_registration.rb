class Risebox::Query::AppRegistration
  attr_reader :app_registration

  def initialize registration
    @app_registration = registration
  end

  def info
    user    = app_registration.user
    devices = user.devices
    data = { user: {id: user.id, first_name: user.first_name, last_name: user.last_name, email: user.email, api_token: user.api_token, admin: user.admin?} ,
             devices: [] }
    devices.each do |device|
      data[:devices] << {name: device.name, key: device.key}
    end
    [true, data]
  rescue
    [false, nil]
  end
end