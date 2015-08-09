class Risebox::Access::User
  def login token
    registration = Risebox::Core::Registration.for_token(token).with_user_and_device.first
    if registration
      user   = registration.user
      device = registration.device
      [true, { user: {first_name: user.first_name, last_name: user.last_name, email: user.email} ,
               device: {name: device.name, key: device.key} }]
    else
      [false, {error: :not_authorized, message: 'No registration matches your token'}]
    end
  end
end