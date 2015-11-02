class Risebox::Access::Device

  def initialize user
  	@user = user
  end

  def device_for_credentials key
  	device = @user.devices.where(key: key).first
    if device
      [true, device]
    else
      [false, {error: :not_authorized, message: 'No device matches your credentials'}]
    end
  end

end