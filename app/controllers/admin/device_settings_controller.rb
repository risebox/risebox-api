class Admin::DeviceSettingsController < ApplicationController
  http_basic_authenticate_with name: 'dg', password: 'dg'

  def index
    @device = Risebox::Core::Device.find_by_key(params[:id])
    @settings = @device.settings.all
  end

  def update
  	@device = Risebox::Core::Device.find_by_key(params[:device_id])
  	@setting = @device.settings.find(params[:id])
  	@setting.update_attribute(:value, settings_params[:value])
    redirect_to admin_device_settings_path(@device.key)
  end

  def settings_params
  	params.require(:device_setting).permit(:value)
  end

end