class API::V1::AppSecuredController < API::V1::APIController
  before_action :secure_access
private
  def secure_access
    success, result = rescuer Risebox::Access::AppRegistration.match_token(request.headers['RISEBOX-APP-REGISTRATION-TOKEN'])
    if success
      @registration = result
      @user = @registration.user
    else
      api_response [false, result]
    end
  end
end