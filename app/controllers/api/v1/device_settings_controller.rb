class API::V1::DeviceSettingsController < API::V1::DeviceSecuredController
  skip_before_filter :verify_authenticity_token, only: :bulk_update
  before_action :load_service

  def index
    api_response settings_for_mode(params[:mode], params[:select])
  end

  def bulk_update
    hash = params[:settings]
    hash = JSON.parse(hash) if hash.is_a?(String)
    bulk_updated, bulk_updates = @service.bulk_update(hash)
    api_response [bulk_updated, bulk_updates]
  end

private

  def load_service
    @service = rescuer Risebox::Query::DeviceSetting.new(@device, @brain_calling)
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