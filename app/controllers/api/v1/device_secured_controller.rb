class API::V1::DeviceSecuredController < API::V1::UserSecuredController
  before_action :secure_access
private
  def secure_access
  	super
  	
  	if @user
  		device_found_and_allowed, result = rescuer(Risebox::Access::Device.new(@user)).device_for_credentials(params[:device_id])
  		if device_found_and_allowed
  			@device = result
  		else
  			api_response [false, result]
  		end
  	end
    
  end
end