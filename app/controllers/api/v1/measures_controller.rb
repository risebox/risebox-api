class API::V1::MeasuresController < API::V1::DeviceSecuredController
  skip_before_filter :verify_authenticity_token, only: :create
  before_action :load_service

  def index
    api_response @service.list(params[:metric_id])
  end

  def create
    created, measure = @service.create(params[:metric_id], params[:value], params[:origin], params[:taken_at])
    api_response [created, measure]
  end

private

  def load_service
    @service = rescuer Risebox::Query::Measure.new(@device)
  end

end