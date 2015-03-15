class API::V1::AlertsController < API::V1::DeviceSecuredController
  before_action :load_service

  def create
    created, alert = @service.create(params[:metric_id], params[:value], params[:description])
    api_response [created, alert]
  end

private

  def load_service
    @service = rescuer Risebox::Query::Alert.new(@device)
  end

end