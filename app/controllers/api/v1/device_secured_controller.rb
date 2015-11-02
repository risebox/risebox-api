class API::V1::DeviceSecuredController < API::V1::APIController
  before_action :retrieve_user_and_device_matching_credentials
private
  def retrieve_user_and_device_matching_credentials
  	user_email = request.headers['RISEBOX-USER-EMAIL']
  	user_api_token = request.headers['RISEBOX-USER-SECRET']
  	app_registration_token = request.headers['RISEBOX-USER-APP-TOKEN']

  	user_ok, result = rescuer(Risebox::Access::User.new).user_for_credentials(user_email, user_api_token, app_registration_token)

  	if user_ok
  		@user = result
  		device_found_and_allowed, result = rescuer(Risebox::Access::Device.new(@user)).device_for_credentials(params[:device_id])
  		if device_found_and_allowed
  			@device = result
  		else
  			api_response [false, result]
  		end
  	else
  		api_response [false, result]
  	end
  end
end