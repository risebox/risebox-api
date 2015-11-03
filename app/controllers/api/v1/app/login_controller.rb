class API::V1::App::LoginController < API::V1::UserSecuredController
  skip_before_filter :verify_authenticity_token
  before_filter :load_service

  def create
    api_response @service.info
  end

private

  def load_service
    @service = rescuer Risebox::Query::AppRegistration.new(@registration)
  end

end