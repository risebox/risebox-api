class API::V1::LoginController < API::V1::AppSecuredController
  skip_before_filter :verify_authenticity_token
  before_filter :load_service

  def login
    api_response @service.info
  end

private

  def load_service
    @service = rescuer Risebox::Query::AppRegistration.new(@registration)
  end

end