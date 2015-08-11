class Risebox::Query::Registration
  attr_reader :registration

  def initialize registration
    @registration = registration
  end

  def info
    user   = registration.user
    device = registration.device
    [true, { user: {first_name: user.first_name, last_name: user.last_name, email: user.email} ,
             device: {name: device.name, key: device.key, token: device.token} }]
  rescue
    [false, nil]
  end
end