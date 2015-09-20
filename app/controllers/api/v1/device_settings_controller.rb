class API::V1::DeviceSettingsController < API::V1::DeviceSecuredController
  before_action :load_service

  def index
    api_response settings_for_mode(params[:mode], params[:select])
  end

private

  def load_service
    @service = rescuer Risebox::Query::DeviceSetting.new(@device)
  end

  def settings_for_mode mode, selection
    list = case mode
    when 'full'
      @service.full_list
    when 'delta'
      @service.delta_list
    when 'select'
      @service.select_list selection.split(',')
    else
      @service.full_list
    end
  end

end