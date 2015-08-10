class API::V1::RegistrationController < API::V1::APIController
  skip_before_filter :verify_authenticity_token, only: :create
  before_filter :retrieve_device, :load_service

  def create
    api_response @service.create nil, params[:origin]
  end

private

  def load_service
    @service = rescuer Risebox::Manage::Registration.new(@device)
  end

  def retrieve_device
    success, result = rescuer(Risebox::Access::Device.new).device_for_credentials(params[:key], params[:token])
    if success
      @device = result
    else
      api_response [false, result]
    end
  end

end