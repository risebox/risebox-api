class API::V1::LoginController < API::V1::APIController
  skip_before_filter :verify_authenticity_token, only: :create
  before_action :load_service

  def create
    api_response @service.login(params[:token])
  end

private

  def load_service
    @service = rescuer Risebox::Access::User.new
  end

end