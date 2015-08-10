class API::V1::AppSecuredController < API::V1::APIController
  before_action :retrieve_registration_matching_token
private
  def retrieve_registration_matching_token
    success, result = rescuer Risebox::Access::Registration.match_token(request.headers['RISEBOX-REGISTRATION-TOKEN'])
    if success
      @registration = result
    else
      api_response [false, result]
    end
  end
end