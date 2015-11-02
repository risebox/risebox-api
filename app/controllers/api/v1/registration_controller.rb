class API::V1::RegistrationController < API::V1::UserSecuredController
  skip_before_filter :verify_authenticity_token, only: :create
  before_filter :load_service

  def create
    created, registration = @service.create @user, params[:origin]
    api_response [created, registration]
  end

private

  def load_service
    @service = rescuer Risebox::Manage::AppRegistration.new
  end

end