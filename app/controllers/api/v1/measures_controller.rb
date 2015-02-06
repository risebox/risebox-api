class API::V1::MeasuresController < API::V1::DeviceSecuredController
  before_action :load_service

  def index
    api_response @service.list(params[:metric_id])
  end

  def create
    created, measure = @service.create(params[:metric_id], params[:value])
    api_response [true, measure]
  end

private

  def load_service
    @service = rescuer Risebox::Query::Measure.new(@device)
  end

end