class API::V1::RegistrationController < API::V1::DeviceSecuredController
  before_action :load_service

  def create
    api_response @service.create nil, params[:origin]
  end

private

  def load_service
    @service = rescuer Risebox::Manage::Registration.new(@device)
  end

end