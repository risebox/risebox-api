class API::V1::App::IonicSecuredController < API::V1::APIController
  before_action :check_app_id, :retrieve_registration_matching_token

private

  def check_app_id
    # if request.headers["X-Ionic-Application-Id"] != IONIC_APP_ID
    if params['app_id'] != IONIC_APP_ID
      api_response [false, {error: :not_authorized, message: 'Ionic Application ID invalid'}]
    end
  end

  def retrieve_registration_matching_token
    success, result = rescuer Risebox::Access::AppRegistration.match_token(params['risebox']['registration_token'])
    if success
      @registration = result
    else
      api_response [false, result]
    end
  end
end