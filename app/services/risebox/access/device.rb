class Risebox::Access::Device
  def device_for_credentials key, secret
    device = Risebox::Core::Device.for_credentials(key, secret).first
    if device
      [true, device]
    else
      [false, {error: :not_authorized, message: 'No device matches your credentials'}]
    end
  end
end