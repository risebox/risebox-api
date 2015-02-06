class API::V1::DeviceSecuredController < API::V1::APIController
  before_action :retrieve_device_matching_credentials
private
  def retrieve_device_matching_credentials
    success, result = rescuer(Risebox::Access::Device.new).device_for_credentials(params[:device_id], request.headers['RISEBOX-SECRET'])
    if success
      @device = result
    else
      api_response [false, result]
    end
  end
end