class Risebox::Manage::AppRegistration

  def build_new creator, origin
    user = creator
    user.registrations.new(origin: origin, made_at: Time.now)
  end

  def create user, origin
    registration = build_new(user, origin)
    [registration.save, registration]
  end

  def find token
    Risebox::Core::AppRegistration.for_token(token).first
  end
end