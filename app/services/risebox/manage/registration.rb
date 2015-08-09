class Risebox::Manage::Registration
  attr_reader :device

  def initialize device
    @device = device
  end

  def build_new creator, origin
    user = creator || device.owner
    user.registrations.new(origin: origin, device_id: device.id, made_at: Time.now)
  end

  def create user, origin
    registration = build_new(user, origin)
    [registration.save, registration]
  end

  def find token
    Risebox::Core::Registration.for_token(token).first
  end
end