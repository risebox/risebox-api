class API::V1::UserSecuredController < API::V1::APIController
  before_action :secure_access
private
  def secure_access
  	user_email     = request.headers['RISEBOX-USER-EMAIL']
    user_secret    = request.headers['RISEBOX-USER-SECRET']
    user_api_token = request.headers['RISEBOX-API-SECRET']
    app_registration_token = request.headers['RISEBOX-APP-REGISTRATION-TOKEN']

    user_ok = false

    if app_registration_token.present?
      user_ok, result = rescuer(Risebox::Access::AppRegistration.new).match_token(app_registration_token)
      if user_ok
        @app_registration = result
        @user = @app_registration.user
      end
    elsif user_email.present? && (user_api_token.present? || user_secret.present?)
      user_ok, result = rescuer(Risebox::Access::User.new).user_for_credentials(user_email, user_api_token || user_secret)
      
      if user_ok
        @user = result
      end
    end

    if user_ok
      @brain_calling = !@user.human?
    else
  		api_response [false, result]
  	end

  end
end