class API::V1::MetricStatsController < API::V1::DeviceSecuredController
  before_action :load_service

  def show
    puts "in show"
    puts "params[:metric_id] #{params[:metric_id]}"
    puts "params[:begin_at] #{params[:begin_at]}"
    since = params[:begin_at].present? ? Time.at(params[:begin_at].to_i).to_datetime : 1.hour.ago
    api_response @service.list_for_stats(params[:metric_id], since)
  end

private

  def load_service
    @service = rescuer Risebox::Query::Measure.new(@device)
  end

end