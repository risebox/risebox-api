class Risebox::Query::AppRegistration
  attr_reader :registration

  def initialize registration
    @registration = registration
  end

  def info
    user    = registration.user
    devices = user.devices
    data = { user: {id: user.id, first_name: user.first_name, last_name: user.last_name, email: user.email, api_token: user.api_token} ,
                    devices: [] }
    devices.each do |device|
      data[:user][:devices] << {name: device.name, key: device.key}
    end
    return [true, data]
  rescue
    [false, nil]
  end
end