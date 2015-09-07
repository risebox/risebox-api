class API::V1::DeviceSettingsController < API::V1::DeviceSecuredController
  before_action :load_service

  def index
    settings = params[:mode] == 'delta' ? @service.delta_list : @service.full_list
    api_response settings
  end

private

  def load_service
    @service = rescuer Risebox::Query::DeviceSetting.new(@device)
  end

end