class API::V1::PushController < API::V1::IonicSecuredController
  skip_before_filter :verify_authenticity_token
  before_action :load_service

  def update_info
    api_response @service.compute(params)
  end

private

  def load_service
    @service = rescuer Risebox::Compute::PushUpdate.new(@registration)
  end


end