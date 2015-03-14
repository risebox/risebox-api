class API::V1::MetricsController < API::V1::DeviceSecuredController
  before_action :load_service

  def index
    api_response @service.list
  end

private

  def load_service
    @service = rescuer Risebox::Query::MetricStatus.new(@device)
  end

end