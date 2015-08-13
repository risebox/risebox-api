class API::V1::PushController < API::V1::APIController
  skip_before_filter :verify_authenticity_token
  before_action :check_app_id, :load_service

  def update_info
    api_response @service.compute
  end

private

  def load_service
    @service = rescuer Risebox::Compute::PushUpdate.new(params)
  end

  def check_app_id
    # if request.headers["X-Ionic-Application-Id"] != ENV['IONIC_APP_ID']
    if params['app_id'] != ENV['IONIC_APP_ID']
      api_response [false, {error: :not_authorized, message: 'Ionic Application ID invalid'}]
    end
  end

end